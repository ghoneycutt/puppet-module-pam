# == Class: pam::accesslogin
#
# Manage login access
#
# See PAM_ACCESS(8)
#
class pam::accesslogin (
  Stdlib::Absolutepath $access_conf_path  = '/etc/security/access.conf',
  String $access_conf_owner               = 'root',
  String $access_conf_group               = 'root',
  Stdlib::Filemode $access_conf_mode      = '0644',
  String $access_conf_template            = 'pam/access.conf.erb',
) {

  require '::pam'

  $allowed_users = $::pam::allowed_users

  case $allowed_users {
    String: {
      $allowed_users_hash = { $allowed_users => 'ALL' }
    }
    Array: {
      $allowed_users_hash = $allowed_users.reduce( {} ) |$memo, $x| {
        $memo + { $x => 'ALL' }
      }
    }
    default: {
      $allowed_users_hash = $allowed_users.reduce( {} ) |$memo, $x| {
        $origin = $x[1] ? {
          String  => $x[1],
          Array   => join($x[1], ' '),
          default => 'ALL',
        }
        $memo + { $x[0] => $origin }
      }
    }
  }

  file { 'access_conf':
    ensure  => file,
    path    => $access_conf_path,
    content => template($access_conf_template),
    owner   => $access_conf_owner,
    group   => $access_conf_group,
    mode    => $access_conf_mode,
    require => Package[$pam::package_name],
  }
}
