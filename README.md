# pam module #

[![Build Status](
https://api.travis-ci.org/ghoneycutt/puppet-module-pam.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-pam)

This module manages bits around PAM.

# Compatibility #

This module has been tested to work on the following systems.

 * EL 5
 * EL 6

# Parameters #

allowed_users
-------------
Array of users allowed to log in.

- *Default*: root

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
Content template of sytem-auth.

- *Default*: '/etc/pam.d/system-auth'

system_auth_file_ac
-------------------
Content template of sytem-auth-ac.

- *Default*: '/etc/pam.d/system-auth-ac'

$system_auth_ac_auth_lines     = undef,
$system_auth_ac_account_lines  = undef,
$system_auth_ac_password_lines = undef,
$system_auth_ac_session_lines  = undef,
