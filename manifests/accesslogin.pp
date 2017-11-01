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
  Pattern[/^[0-7]{4}$/] $access_conf_mode = '0644',
  String $access_conf_template            = 'pam/access.conf.erb',
) {

  require '::pam'

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
