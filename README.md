puppet-module-nsswitch
===

Puppet module to manage nsswitch that optionally allows for LDAP integration.

# Compatibility #
  * EL 5
  * EL 6

# Parameters #
[*config_file*]
Path to configuration file
- *Default*: `/etc/nsswitch.conf`

[*ensure_ldap*]
Should LDAP be used? Valid values are 'absent' and 'present'
- *Default*: 'absent'
