# == Define: pam::genericaccess
#
# Manage access for any service
#
# See PAM_ACCESS(8)
#
define pam::genericaccess (
  $genericaccess_conf_path     = "/etc/security/${name}.conf",
  $genericaccess_conf_owner    = 'root',
  $genericaccess_conf_group    = 'root',
  $genericaccess_conf_mode     = '0644',
  $genericaccess_conf_template = 'pam/genericaccess.conf.erb',
  $genericaccess_conf_allow    = undef,
) {

  require '::pam'

  file { "${name}_access_conf":
    ensure  => file,
    path    => $genericaccess_conf_path,
    content => template($genericaccess_conf_template),
    owner   => $genericaccess_conf_owner,
    group   => $genericaccess_conf_group,
    mode    => $genericaccess_conf_mode,
  }
}
