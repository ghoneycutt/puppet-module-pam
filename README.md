# pam module


[![Build Status](
https://api.travis-ci.org/ghoneycutt/puppet-module-pam.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-pam)

This module manages PAM including accesslogin and limits.conf with functionality to create limits fragments for use in other modules.

===

# Compatibility

This module has been tested to work on the following systems with Puppet v3
(with and without the future parser) and v4 with Ruby versions 1.8.7 (Puppet v3
only), 1.9.3, 2.0.0, 2.1.0 and 2.3.1 (Puppet v4 only).

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
 * Debian 8

EL no longer requires the `redhat-lsb` package.

===

# Parameters

## class pam


allowed_users
-------------
String, Array or Hash of strings and/or arrays to configure users and origins in access.conf. The default allows the root user/group from origin 'ALL'.

- *Default*: 'root'

# Hiera example for allowed_users
<pre>
# as an array where the origin for each is 'ALL'
pam::allowed_users:
  - root
  - ops
  - devs
</pre>

This would create /etc/security/access.conf with the following content.
<pre>
# This file is being maintained by Puppet.
# DO NOT EDIT
#

#allow only the groups listed
+ : root : ALL
+ : ops : ALL
+ : devs : ALL
</pre>

<pre>
# as a hash where the user/group can optionally specify the origin
pam::allowed_users:
  'username':
  'username1':
    - 'cron'
    - 'tty0'
  'username2': 'tty1'
</pre>

This would create /etc/security/access.conf with the following content.
<pre>
# This file is being maintained by Puppet.
# DO NOT EDIT
#

#allow only the groups listed
+ : username : ALL
+ : username1 : cron tty0
+ : username2 : tty1
</pre>

login_pam_access
----------------
Control module to be used for pam_access.so for login. Valid values are 'required', 'requisite', 'sufficient', 'optional' and 'absent'.

- *Default*: 'required'

sshd_pam_access
---------------
Control module to be used for pam_access.so for sshd. Valid values are 'required', 'requisite', 'sufficient', 'optional' and 'absent'.

- *Default*: 'required'

limits_fragments
----------------
Hash of fragments to pass to pam::limits::fragments

- *Default*: undef

limits_fragments_hiera_merge
----------------------------
Boolean to control merges of all found instances of pam::limits_fragments in Hiera. This is useful for specifying fragments at different levels of the hierarchy and having them all included in the catalog.

- *Default*: false

package_name
------------
String or Array of packages providing the pam functionality. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_conf_file
-------------
Path to pam.conf

- *Default*: '/etc/pam.conf'

pam_d_login_oracle_options
--------------------------
Allow array of extra lines at the bottom of pam.d/login for oracle systems on EL5.

- *Default*: UNSET

pam_d_login_path
----------------
PAM login path

- *Default*: '/etc/pam.d/login'

pam_d_login_owner
-----------------
Owner of $pam_d_login_path

- *Default*: 'root'

pam_d_login_group
-----------------
Group of $pam_d_login_path

- *Default*: 'root'

pam_d_login_mode
----------------
Mode of $pam_d_login_path

- *Default*: '0644'

pam_d_login_template
--------------------
Content template of $pam_d_login_path. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_d_sshd_path
---------------
PAM sshd path

- *Default*: '/etc/pam.d/sshd'

pam_d_sshd_owner
----------------
Owner of $pam_d_sshd_path

- *Default*: 'root'

pam_d_sshd_group
----------------
Group of $pam_d_sshd_path

- *Default*: 'root'

pam_d_sshd_mode
---------------
Mode of $pam_d_sshd_path

- *Default*: '0644'

pam_d_sshd_template
-------------------
Content template of $pam_d_sshd_path. If undef, parameter is set based on the OS version.

For cases where a full customization of the sshd PAM configuration is required, set pam_d_sshd_template to use pam/sshd.custom.erb that is provided with this module.
pam/sshd.custom.erb must be further configured with the parameters pam_sshd_auth_lines, pam_sshd_account_lines, pam_sshd_password_lines and pam_sshd_session_lines.
Note that the pam_d_sshd_template parameter is a no-op on Solaris.

- *Default*: undef, default is set based on OS version

pam_sshd_auth_lines
-------------------
An ordered array of strings that define the content for PAM sshd auth. This setting is required and only valid if pam_d_sshd_template is configured to use the pam/sshd.custom.erb template.

- *Default*: undef

pam_sshd_account_lines
----------------------
An ordered array of strings that define the content for PAM sshd account. This setting is required and only valid if pam_d_sshd_template is configured to use the pam/sshd.custom.erb template.

- *Default*: undef

pam_sshd_password_lines
-----------------------
An ordered array of strings that define the content for PAM sshd password. This setting is required and only valid if pam_d_sshd_template is configured to use the pam/sshd.custom.erb template.

- *Default*: undef

pam_sshd_session_lines
----------------------
An ordered array of strings that define the content for PAM sshd session. This setting is required and only valid if pam_d_sshd_template is configured to use the pam/sshd.custom.erb template.

- *Default*: undef

pam_auth_lines
--------------
An ordered array of strings that define the content for PAM auth. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_account_lines
-----------------
An ordered array of strings that define the content for PAM account. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_password_lines
------------------
An ordered array of strings that define the content for PAM password. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_session_lines
-----------------
An ordered array of strings that define the content for PAM session. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_d_other_file
----------------
Path to other. Used on Suse.

- *Default*: '/etc/pam.d/other'

common_auth_file
----------------
Path to common-auth. Used on Suse.

- *Default*: '/etc/pam.d/common-auth'

common_auth_pc_file
-------------------
Path to common-auth-pc. Used on Suse.

- *Default*: '/etc/pam.d/common-auth-pc'

common_account_file
-------------------
Path to common-account. Used on Suse.

- *Default*: '/etc/pam.d/common-account'

common_account_pc_file
----------------------
Path to common-account-pc. Used on Suse.

- *Default*: '/etc/pam.d/common-account-pc'

common_password_file
--------------------
Path to common-password. Used on Suse.

- *Default*: '/etc/pam.d/common-password'

common_password_pc_file
-----------------------
Path to common-password-pc. Used on Suse.

- *Default*: '/etc/pam.d/common-password-pc'

common_session_file
-------------------
Path to common-session. Used on Suse.

- *Default*: '/etc/pam.d/common-session'

common_session_pc_file
----------------------
Path to common-session-pc. Used on Suse.

- *Default*: '/etc/pam.d/common-session-pc'

common_session_noninteractive_file
----------------------------------
Path to common-session-noninteractive, which is the same as common-session-pc used on Suse. Used on Ubuntu 12.04 LTS.

- *Default*: '/etc/pam.d/common-session-noninteractive'

system_auth_file
----------------
Path to system-auth. Used on RedHat.

- *Default*: '/etc/pam.d/system-auth'

system_auth_ac_file
-------------------
Path to system-auth-ac. Used on RedHat.

- *Default*: '/etc/pam.d/system-auth-ac'

system_auth_ac_auth_lines
-------------------------
Content template of $system_auth_ac_file. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

system_auth_ac_account_lines
----------------------------
Content template of $system_auth_ac_file. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

system_auth_ac_password_lines
-----------------------------
Content template of $system_auth_ac_file. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

system_auth_ac_session_lines
----------------------------
Content template of $system_auth_ac_file. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

password_auth_file
----------------
Path to password-auth. Used on RedHat.

- *Default*: '/etc/pam.d/password-auth'

password_auth_ac_file
-------------------
Path to password-auth-ac. Used on RedHat.

- *Default*: '/etc/pam.d/password-auth-ac'

pam_password_auth_lines
-------------------------
Array of lines used in content template of $password_auth_ac_file. If undef, parameter is set based on defaults for the detected platform.

- *Default*: undef, default is set based on OS version

pam_password_account_lines
----------------------------
Array of lines used in content template of $password_auth_ac_file. If undef, parameter is set based on defaults for the detected platform.

- *Default*: undef, default is set based on OS version

pam_password_password_lines
-----------------------------
Array of lines used in content template of $password_auth_ac_file. If undef, parameter is set based on defaults for the detected platform.

- *Default*: undef, default is set based on OS version

pam_password_session_lines
----------------------------
Array of lines used in content template of $password_auth_ac_file. If undef, parameter is set based on defaults for the detected platform.

- *Default*: undef, default is set based on OS version
===

# define pam::accesslogin
Manages login access
See PAM_ACCESS(8)

## Parameters for `pam::accesslogin` define

access_conf_path
----------------
Path to access.conf.

- *Default*: '/etc/security/access.conf'

access_conf_owner
-----------------
Owner of access.conf.

- *Default*: 'root'

access_conf_group
-----------------
Group of access.conf.

- *Default*: 'root'

access_conf_mode
----------------
Mode of access.conf.

- *Default*: '0644'

access_conf_template
--------------------
Content template of access.conf.

- *Default*: 'pam/access.conf.erb'

===

# class pam::limits
Manage PAM limits.conf

## Parameters for `pam::limits`

config_file
-----------
Path to limits.conf

- *Default*: '/etc/security/limits.conf'

config_file_mode
----------------
Mode for config_file.

- *Default*: '0640'

config_file_lines
--------------------
Ordered array of limits that should be placed into limits.conf.
Useful for Suse 10 which does not use limits.d.

- *Default*: undef

config_file_source
------------------
String with source path to a limits.conf

- *Default*: undef


limits_d_dir
------------
Path to limits.d directory

- *Default*: '/etc/security/limits.d'

limits_d_dir_mode
-----------------
Mode for limits_d_dir.

- *Default*: '0750'

purge_limits_d_dir
------------------
Boolean to purge the limits.d directory.

- *Default*: false

===

# pam::limits::fragment define
Places a fragment in $limits_d_dir directory

## Parameters for `pam::limits::fragment`
Source or list **must** be set.

ensure
------
String with ensure attribute for the fragment file. Valid values are 'file', 'present' and 'absent'.

- *Default*: 'file'

source
------
String - Path to the fragment file, such as 'puppet:///modules/pam/limits.nproc'

- *Default*: 'UNSET'

list
----
Array of lines to add to the fragment file

- *Default*: undef

===

# pam::service
Manage PAM file for specific service. The `pam::service` resource is reversible, so that any service that Puppet has locked using PAM can be unlocked by setting the resource ensure to absent and waiting for the next puppet run.

## Usage
you can specify a hash for to manage the services in Hiera
<pre>
pam::services:
  "sudo":
    content : "auth     required       pam_unix2.so"
</pre>

## Parameters for `pam::service`

ensure
------

Specifies if a PAM service file should (`present`) or should not (`absent`) exist. The default is set to 'present'

pam_config_dir
--------------
Path to PAM files

- *Default*: '/etc/pam.d/'

content
-------
Content of the PAM file for the service. The `content` and `lines` parameters are mutually exclusive. Not setting either of these parameters will result in an empty service definition file.

lines
-----
Provides content for the PAM service file as an array of lines. The `content` and `lines` parameters are mutually exclusive. Not setting either of these parameters will result in an empty service definition file.

===

# Hiera example for limits_fragments
<pre>
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
</pre>

This would create /etc/security/limits.d/custom.conf with content
<pre>
# This file is being maintained by Puppet.
# DO NOT EDIT
* soft nofile 2048
* hard nofile 8192
* soft as 3145728
* hard as 4194304
* hard maxlogins 300
* soft cpu 720
* hard cpu 1440
</pre>
