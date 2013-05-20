# pam module #

[![Build Status](
https://api.travis-ci.org/ghoneycutt/puppet-pam.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-pam)

This module manages bits around PAM.

It makes use of Hiera (http://github.com/puppetlabs/hiera) and demonstrates a
new design pattern in module development that allows for totally data driven
code with no modifications to the module itself as a guiding principle.

# Compatibility #

This module has been tested to work on the following systems.

 * Ubuntu 12.04 LTS (Precise Pangolin)

# Parameters #

allowed_users
-----------
Array of users allowed to log in.

- *Default*: root

package_name
-------
Array of packages providing the pam functionality. If undef, parameter will be set to default_package_name, wich is set using case statement.

- *Default*: undef, default is set based on lsbmajordistrelease

pam_d_login_oracle_options
------
Allow array of extra lines at the bottom of pam.d/login for oracle systems on EL5.

- *Default*: UNSET

pam_d_login_path
------
PAM login path

- *Default*: '/etc/pam.d/login'

pam_d_login_owner
--------
Owner of $pam_d_login_path

- *Default*: 'root'

pam_d_login_group
--------------------
Group of $pam_d_login_path

- *Default*: 'root'

pam_d_login_mode
---------------------------
Mode of $pam_d_login_path

- *Default*: '0644'

pam_d_login_template
--------------------------
Content template of $pam_d_login_path. If undef, parameter will be set to default_pam_d_login_template, which is set using case statement.

- *Default*: undef, default is set based on lsbmajordistrelease

pam_d_sshd_path
------
PAM sshd path

- *Default*: '/etc/pam.d/sshd'

pam_d_sshd_owner
--------
Owner of $pam_d_sshd_path

- *Default*: 'root'

pam_d_sshd_group
--------------------
Group of $pam_d_sshd_path

- *Default*: 'root'

pam_d_sshd_mode
---------------------------
Mode of $pam_d_sshd_path

- *Default*: '0644'

pam_d_sshd_template
--------------------------
Content template of $pam_d_sshd_path. If undef, parameter will be set to default_pam_d_sshd_template, wich is set using case statement.

- *Default*: undef, default is set based on lsbmajordistrelease

system_auth_file
--------------------------
Content template of sytem-auth.

- *Default*: '/etc/pam.d/system-auth'

system_auth_file_ac
--------------------------
Content template of sytem-auth-ac.

- *Default*: '/etc/pam.d/system-auth-ac'

$system_auth_ac_auth_lines     = undef,
$system_auth_ac_account_lines  = undef,
$system_auth_ac_password_lines = undef,
$system_auth_ac_session_lines  = undef,
