# pam module #

[![Build Status](
https://api.travis-ci.org/ghoneycutt/puppet-module-pam.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-pam)

This module manages bits around PAM.

# Compatibility #

This module has been tested to work on the following systems.

 * EL 5
 * EL 6

# Parameters #

package_name
------------
Array of packages providing the pam functionality. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

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

- *Default*: undef, default is set based on OS version

system_auth_file
----------------
Path to system-auth.

- *Default*: '/etc/pam.d/system-auth'

system_auth_ac_file
-------------------
Path to system-auth-ac

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

===

# pam::accesslogin define #
Manages login access
See PAM_ACCESS(8)

## Parameters for `pam::accesslogin` define ##

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

allowed
-------------
Array of users and groups allowed to log in.

- *Default*: root

===

# pam::limits define #
Manage PAM limits.conf

## Parameters for `pam::limits` define ##

config_file
-----------
Path to limits.conf

- *Default*: '/etc/security/limits.conf'

limits_d_dir
------------
Path to limits.d directory

- *Default*: '/etc/security/limits.d'

===

# pam::limits::fragment define #
Places a fragment in $limits_d_dir directory

## Parameters for `pam::limits::fragment` ##

source
------
Path to the fragment file

- *Required*
===
