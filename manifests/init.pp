# == Class: nsswitch
#
# This module manages nsswitch.
#
class nsswitch (
  $config_file    = '/etc/nsswitch.conf',
  $ensure_ldap    = 'absent',
  $ensure_vas     = 'absent',
  $vas_nss_module = 'vas4',
) {

  validate_absolute_path($config_file)
  validate_re($ensure_ldap, '^(present|absent)$',
    'Valid values for ensure_ldap are \'absent\' and \'present\'.')
  validate_re($ensure_vas, '^(present|absent)$',
    'Valid values for ensure_vas are \'absent\' and \'present\'.')
  validate_re($vas_nss_module, '^vas(3|4)$',
    'Valid values for vas_nss_module are \'vas3\' and \'vas4\'.')

  file { 'nsswitch_config_file':
    ensure  => file,
    path    => $config_file,
    content => template('nsswitch/nsswitch.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
