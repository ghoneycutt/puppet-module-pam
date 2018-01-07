# puppet-module-pam

#### Table of Contents

1. [Module Description](#module-description)
2. [Compatibility](#compatibility)
2. [SSSD](#sssd)
3. [Class Descriptions](#class-descriptions)
    * [pam](#class-pam)
    * [pam::accesslogin](#class-pamaccesslogin)
    * [pam::limits](#class-pamlimits)
4. [Define Descriptions](#define-descriptions)
    * [pam::limits::fragment](#defined-type-pamlimitsfragment)
    * [pam::service](#defined-type-pamservice)

# Module description

This module manages PAM including accesslogin and limits.conf with
functionality to create limits fragments for use in other modules.

# Compatibility

This module has been tested to work on the following systems with Puppet
v3 (with and without the future parser) and v4 with Ruby versions 1.8.7,
1.9.3, 2.0.0 and 2.1.9. Please see .travis.yml for a full matrix of
versions.

 * EL 5
 * EL 6
 * EL 7
 * Solaris 9
 * Solaris 10
 * Solaris 11
 * Suse 9
 * Suse 10
 * Suse 11
 * Suse 12
 * OpenSuSE 13.1
 * Ubuntu 12.04 LTS
 * Ubuntu 14.04 LTS
 * Ubuntu 16.04 LTS
 * Debian 7
 * Debian 8

[![Build Status](https://api.travis-ci.org/ghoneycutt/puppet-module-pam.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-pam)

# SSSD

This module has been deployed in production along with
[sgnl05/sssd](https://github.com/sgnl05/sgnl05-sssd). Please see
[examples/hiera/sssd/RedHat-6.yaml](examples/hiera/sssd/RedHat-6.yaml)
file for an example with the additional SSSD entries added via hiera.

# Class Descriptions
## Class `pam`

### Description

### Parameters

---
#### allowed_users (type: String, Array, Hash)
String, Array or Hash of strings and/or arrays to configure users and
origins in access.conf. The default allows the root user/group from
origin 'ALL'.

- *Default*: 'root'

For Examples check [pam::accesslogin::allowed_users](#allowed_users-type-string-array-hash-1)

---
#### login_pam_access (type: String)
Control module to be used for pam_access.so for login. Valid values are
'required', 'requisite', 'sufficient', 'optional' and 'absent'.

- *Default*: 'required'

---
#### sshd_pam_access (type: String)
Control module to be used for pam_access.so for sshd. Valid values are
'required', 'requisite', 'sufficient', 'optional' and 'absent'.

- *Default*: 'required'

---
#### limits_fragments (type: Hash)
Hash of fragments to pass to pam::limits::fragments

- *Default*: undef


##### Example:
Hiera example for limits_fragments
```yaml
pam::limits_fragments:
  custom:
    list:
      - '* soft nofile 2048'
      - '* hard nofile 8192'
      - '* soft as 3145728'
      - '* hard as 4194304'
      - '* hard maxlogins 300'
      - '* soft cpu 720'
      - '* hard cpu 1440'
```

This would create /etc/security/limits.d/custom.conf with content
```
# This file is being maintained by Puppet.
# DO NOT EDIT
* soft nofile 2048
* hard nofile 8192
* soft as 3145728
* hard as 4194304
* hard maxlogins 300
* soft cpu 720
* hard cpu 1440
```
---
#### limits_fragments_hiera_merge (type: Boolean)
Boolean to control merges of all found instances of pam::limits_fragments
in Hiera. This is useful for specifying fragments at different levels of
the hierarchy and having them all included in the catalog.

- *Default*: false

---
#### package_name (type: String, Array)
String or Array of packages providing the pam functionality.
If undef, parameter is set based on the OS version.

- *Default*: undef

---
#### pam_conf_file (type: Stdlib::Absolutepath)
Absolute path to pam.conf.

- *Default*: '/etc/pam.conf'

---
#### pam_d_login_oracle_options (type: Array)
Allow array of extra lines at the bottom of pam.d/login for oracle systems on EL5.

- *Default*: []

---
#### pam_d_login_path (type: Stdlib::Absolutepath)
Absolute path to PAM login file.

- *Default*: '/etc/pam.d/login'

---
#### pam_d_login_owner (type: String)
Owner of $pam_d_login_path.

- *Default*: 'root'

---
#### pam_d_login_group (type: String)
Group of $pam_d_login_path.

- *Default*: 'root'

---
#### pam_d_login_mode (type: Stdlib::Filemode)
Mode of $pam_d_login_path.

- *Default*: '0644'

---
#### pam_d_login_template (type: String)
Content template of $pam_d_login_path.
If undef, parameter is set based on the OS version.

- *Default*: undef

---
#### pam_d_sshd_path (type: Stdlib::Absolutepath)
PAM sshd path.

- *Default*: '/etc/pam.d/sshd'

---
#### pam_d_sshd_owner (type: String)
Owner of $pam_d_sshd_path.

- *Default*: 'root'

---
#### pam_d_sshd_group (type: String)
Group of $pam_d_sshd_path.

- *Default*: 'root'

---
#### pam_d_sshd_mode (type: Stdlib::Filemode)
Mode of $pam_d_sshd_path.

- *Default*: '0644'

---
#### pam_d_sshd_template (type: String)
Content template of $pam_d_sshd_path.
If undef, parameter is set based on the OS version.

For cases where a full customization of the sshd PAM configuration is
required, set pam_d_sshd_template to use pam/sshd.custom.erb that is
provided with this module.
pam/sshd.custom.erb must be further configured with the parameters
pam_sshd_auth_lines, pam_sshd_account_lines, pam_sshd_password_lines
and pam_sshd_session_lines.
Note that the pam_d_sshd_template parameter is a no-op on Solaris.

- *Default*: undef

---
#### pam_sshd_auth_lines (type: Array)
An ordered array of strings that define the content for PAM sshd auth.
This setting is required and only valid if pam_d_sshd_template is
configured to use the pam/sshd.custom.erb template.

- *Default*: undef

---
#### pam_sshd_account_lines (type: Array)
An ordered array of strings that define the content for PAM sshd account.
This setting is required and only valid if pam_d_sshd_template is
configured to use the pam/sshd.custom.erb template.

- *Default*: undef

---
#### pam_sshd_password_lines (type: Array)
An ordered array of strings that define the content for PAM sshd password.
This setting is required and only valid if pam_d_sshd_template is
configured to use the pam/sshd.custom.erb template.

- *Default*: undef

---
#### pam_sshd_session_lines (type: Array)
An ordered array of strings that define the content for PAM sshd session.
This setting is required and only valid if pam_d_sshd_template is
configured to use the pam/sshd.custom.erb template.

- *Default*: undef

---
#### pam_auth_lines (type: Array)
An ordered array of strings that define the content for PAM auth.
If undef, parameter is set based on the OS version.

- *Default*: undef

---
#### pam_account_lines (type: Array)
An ordered array of strings that define the content for PAM account.
If undef, parameter is set based on the OS version.

- *Default*: undef

---
#### pam_password_lines (type: Array)
An ordered array of strings that define the content for PAM password.
If undef, parameter is set based on the OS version.

- *Default*: undef

---
#### pam_session_lines (type: Array)
An ordered array of strings that define the content for PAM session.
If undef, parameter is set based on the OS version.

- *Default*: undef

---
#### other_file (type: Stdlib::Absolutepath)
Path to PAM other file. Used on Suse 9 and Solaris.

- *Default*: '/etc/pam.d/other'

---
#### common_auth_file (type: Stdlib::Absolutepath)
Path to PAM common-auth file. Used on Debian/Ubuntu and Suse.

- *Default*: '/etc/pam.d/common-auth'

---
#### common_auth_pc_file (type: Stdlib::Absolutepath)
Path to PAM common-auth-pc file. Used on Suse.

- *Default*: '/etc/pam.d/common-auth-pc'

---
#### common_account_file (type: Stdlib::Absolutepath)
Path to PAM common-account file. Used on Suse.

- *Default*: '/etc/pam.d/common-account'

---
#### common_account_pc_file (type: Stdlib::Absolutepath)
Path to PAM common-account-pc file. Used on Suse.

- *Default*: '/etc/pam.d/common-account-pc'

---
#### common_password_file (type: Stdlib::Absolutepath)
Path to PAM common-password file. Used on Suse.

- *Default*: '/etc/pam.d/common-password'

---
#### common_password_pc_file (type: Stdlib::Absolutepath)
Path to PAM common-password-pc file. Used on Suse.

- *Default*: '/etc/pam.d/common-password-pc'

---
#### common_session_file (type: Stdlib::Absolutepath)
Path to PAM common-session file. Used on Suse.

- *Default*: '/etc/pam.d/common-session'

---
#### common_session_pc_file (type: Stdlib::Absolutepath)
Path to PAM common-session-pc file. Used on Suse.

- *Default*: '/etc/pam.d/common-session-pc'

---
#### common_session_noninteractive_file (type: Stdlib::Absolutepath)
Path to PAM common-session-noninteractive file, which is the same as
common-session-pc used on Suse. Used on Ubuntu 12.04 LTS.

- *Default*: '/etc/pam.d/common-session-noninteractive'

---
#### system_auth_file (type: Stdlib::Absolutepath)
Path to PAM system-auth file. Used on RedHat.

- *Default*: '/etc/pam.d/system-auth'

---
#### system_auth_ac_file (type: Stdlib::Absolutepath)
Path to PAM system-auth-ac file. Used on RedHat.

- *Default*: '/etc/pam.d/system-auth-ac'

---
#### password_auth_file (type: Stdlib::Absolutepath)
Path to PAM password-auth file. Used on RedHat.

- *Default*: '/etc/pam.d/password-auth'

---
#### password_auth_ac_file (type: Stdlib::Absolutepath)
Path to PAM password-auth-ac file. Used on RedHat.

- *Default*: '/etc/pam.d/password-auth-ac'

---
#### pam_password_auth_lines (type: Array)
Array of lines used in content template of $password_auth_ac_file.
If undef, parameter is set based on defaults for the detected platform.

- *Default*: undef

---
#### pam_password_account_lines (type: Array)
Array of lines used in content template of $password_auth_ac_file.
If undef, parameter is set based on defaults for the detected platform.

- *Default*: undef

---
#### pam_password_password_lines (type: Array)
Array of lines used in content template of $password_auth_ac_file.
If undef, parameter is set based on defaults for the detected platform.

- *Default*: undef

---
#### pam_password_session_lines (type: Array)
Array of lines used in content template of $password_auth_ac_file.
If undef, parameter is set based on defaults for the detected platform.

- *Default*: undef

---
#### manage_nsswitch (type: Boolean)
Boolean to manage the inclusion of the nsswitch class.

- *Default*: true

---

## Class `pam::accesslogin`

### Description
Manages login access. See PAM_ACCESS(8)

### Parameters

---
#### access_conf_path (type: Stdlib::Absolutepath)
Path to access.conf.

- *Default*: '/etc/security/access.conf'

---
#### access_conf_owner (type: String)
Owner of access.conf.

- *Default*: 'root'

---
#### access_conf_group (type: String)
Group of access.conf.

- *Default*: 'root'

---
#### access_conf_mode (type: Stdlib::Filemode)
Mode of access.conf.

- *Default*: '0644'

---
#### access_conf_template (type: String)
Content template of access.conf.

- *Default*: 'pam/access.conf.erb'

---
#### allowed_users (type: String, Array, Hash)
String, Array or Hash of strings and/or arrays to configure users and
origins in access.conf. The default allows the root user/group from
origin 'ALL'.

- *Default*: $pam::allowed_users (resolves to 'root')

##### Examples:
as an array where the origin for each is 'ALL'

```yaml
pam::allowed_users:
  - root
  - ops
  - devs
```

This would create /etc/security/access.conf with the following content.
```
# This file is being maintained by Puppet.
# DO NOT EDIT
#

#allow only the groups listed
+ : root : ALL
+ : ops : ALL
+ : devs : ALL
```

as a hash where the user/group can optionally specify the origin

```yaml
pam::allowed_users:
  'username':
  'username1':
    - 'cron'
    - 'tty0'
  'username2': 'tty1'
```

This would create /etc/security/access.conf with the following content.
```
# This file is being maintained by Puppet.
# DO NOT EDIT
#

#allow only the groups listed
+ : username : ALL
+ : username1 : cron tty0
+ : username2 : tty1
```
---

## Class `pam::limits`

### Description
Manage PAM limits.conf

### Parameters

---
#### config_file (type: Stdlib::Absolutepath)
Path to limits.conf.

- *Default*: '/etc/security/limits.conf'

---
#### config_file_mode (type: Stdlib::Filemode)
Mode for config_file.

- *Default*: '0640'

---
#### config_file_lines (type: Array)
Ordered array of limits that should be placed into limits.conf.
Useful for Suse 10 which does not use limits.d.

- *Default*: undef

---
#### config_file_source (type: String)
String with source path to a limits.conf

- *Default*: undef

---
#### limits_d_dir (type: Stdlib::Absolutepath)
Path to limits.d directory.

- *Default*: '/etc/security/limits.d'

---
#### limits_d_dir_mode (type: Stdlib::Filemode)
Mode for limits_d_dir.

- *Default*: '0750'

---
#### purge_limits_d_dir (type: Boolean)
Boolean to purge the limits.d directory.

- *Default*: false

---

# Define Descriptions
## Defined type `pam::limits::fragment`

### Description
Places a fragment in $limits_d_dir directory
One of the parameters source or list **must** be set.

### Parameters

---
#### ensure (type: String)
String with ensure attribute for the fragment file.
Valid values are 'file', 'present' and 'absent'.

- *Default*: 'file'

---
#### source (type: String)
String - Path to the fragment file, such as
'puppet:///modules/pam/limits.nproc'

- *Default*: undef

---
#### list (type: Array)
Array of lines to add to the fragment file.

- *Default*: undef

---

## Defined type `pam::service`

### Description
Manage PAM file for specific service. The `pam::service` resource is reversible,
so that any service that Puppet has locked using PAM can be unlocked by setting
the resource ensure to absent and waiting for the next puppet run.

#### Example
You can specify a hash for to manage the services in Hiera
```yaml
pam::services:
  'sudo':
    content : 'auth     required       pam_unix2.so'
```
---

### Parameters

---
#### ensure (type: String)
Specifies if a PAM service file should (`present`) or should not (`absent`) exist.
The default is set to 'present'

---
#### pam_config_dir (type: Stdlib::Absolutepath)
Path to PAM files.

- *Default*: '/etc/pam.d/'

---
#### content (type: String)
Content of the PAM file for the service. The `content` and `lines` parameters
are mutually exclusive. Not setting either of these parameters will result in
an empty service definition file.

- *Default*: undef

---
### lines (type: Array)
Provides content for the PAM service file as an array of lines. The `content`
and `lines` parameters are mutually exclusive. Not setting either of these
parameters will result in an empty service definition file.

- *Default*: undef


