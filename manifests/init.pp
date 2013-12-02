# == Class: nsswitch
#
# This module manages nsswitch.
#
class nsswitch (
  $config_file              = '/etc/nsswitch.conf',
  $ensure_ldap              = 'absent',
  $ensure_vas               = 'absent',
  $vas_nss_module_passwd    = 'vas4',
  $vas_nss_module_group     = 'vas4',
  $vas_nss_module_automount = 'nis',
  $vas_nss_module_netgroup  = 'nis',
  $vas_nss_module_aliases   = '',
  $vas_nss_module_services  = '',
) {

  validate_absolute_path($config_file)
  validate_re($ensure_ldap, '^(present|absent)$',
    'Valid values for ensure_ldap are \'absent\' and \'present\'.')
  validate_re($ensure_vas, '^(present|absent)$',
    'Valid values for ensure_vas are \'absent\' and \'present\'.')
  validate_string($vas_nss_module_passwd)
  validate_string($vas_nss_module_group)
  validate_string($vas_nss_module_automount)
  validate_string($vas_nss_module_netgroup)
  validate_string($vas_nss_module_aliases)
  validate_string($vas_nss_module_services)

  file { 'nsswitch_config_file':
    ensure  => file,
    path    => $config_file,
    content => template('nsswitch/nsswitch.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
