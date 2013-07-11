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
class nsswitch (
  $config_file = '/etc/nsswitch.conf',
  $ensure_ldap = 'absent',
) {

  validate_absolute_path($config_file)
  validate_re($ensure_ldap, '^(present|absent)$', "Valid values for ensure_ldap are \'absent\' and \'present\'.")

  file { 'nsswitch_config_file':
    ensure  => file,
    path    => $config_file,
    content => template('nsswitch/nsswitch.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
