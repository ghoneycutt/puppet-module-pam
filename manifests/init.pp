# == Class: nsswitch
#
# This module manages nsswitch.
#
# == Parameters:
#
# [*config_file*]
# Path to configuration file
# - *Default*: `/etc/nsswitch.conf`
#
# [*ensure_ldap*]
# Should LDAP be used? Valid values are 'absent' and 'present'
# - *Default*: 'absent'
#
# [*ensure_qas*]
# Should QAS (Quest Authentication Services) be used? Valid values are 'absent'
# and 'present'
# - *Default*: 'absent'
#
# [*qas_nss_module*]
# Name of NSS module to use for QAS
# - *Default*: 'vas4'
#
class nsswitch (
  $config_file    = '/etc/nsswitch.conf',
  $ensure_ldap    = 'absent',
  $ensure_qas     = 'absent',
  $qas_nss_module = 'vas4',
) {

  validate_absolute_path($config_file)
  validate_re($ensure_ldap, '^(present|absent)$',
    'Valid values for ensure_ldap are \'absent\' and \'present\'.')
  validate_re($ensure_qas, '^(present|absent)$',
    'Valid values for ensure_qas are \'absent\' and \'present\'.')
  validate_re($qas_nss_module, '^vas(3|4)$',
    'Valid values for qas_nss_module are \'vas3\' and \'vas4\'.')

  file { 'nsswitch_config_file':
    ensure  => file,
    path    => $config_file,
    content => template('nsswitch/nsswitch.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
