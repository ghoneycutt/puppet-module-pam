# ghoneycutt/nsswitch #

[![Build Status](
https://api.travis-ci.org/ghoneycutt/puppet-module-nsswitch.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-nsswitch)

Puppet module to manage nsswitch that optionally allows for LDAP and VAS integration.

===

# Compatibility #
  * EL 5
  * EL 6
  * Solaris 10

===

# Parameters #
[*config_file*]
Path to configuration file.
- *Default*: `/etc/nsswitch.conf`

[*ensure_ldap*]
Should LDAP be used? Valid values are 'absent' and 'present'
- *Default*: 'absent'

[*ensure_vas*]
Should VAS (Quest Authentication Services) be used? Valid values are 'absent'
and 'present'.
- *Default*: 'absent'

[*vas_nss_module*]
Name of NSS module to use for VAS.
- *Default*: 'vas4'
