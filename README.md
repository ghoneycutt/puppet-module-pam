# pam module


[![Build Status](
https://api.travis-ci.org/ghoneycutt/puppet-module-pam.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-pam)

This module manages PAM including accesslogin and limits.conf with functionality to create limits fragments for use in other modules.

===

# Compatibility

This module has been tested to work on the following systems using Puppet v3 with Ruby versions 1.8.7, 1.9.3, and 2.0.0.

 * EL 5
 * EL 6
 * Solaris 9
 * Solaris 10
 * Solaris 11
 * Suse 9
 * Suse 10
 * Suse 11
 * Ubuntu 12.04 LTS
 * Ubuntu 14.04 LTS

===

# Parameters

## class pam


allowed_users
-------------
Array or Hash of strings and/or arrays to configure users and origins in access.conf. The default allows the root user/group from origin 'ALL'.

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

limits_fragments
----------------
Hash of fragments to pass to pam::limits::fragments

- *Default*: undef

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

- *Default*: undef, default is set based on OS version

pam_auth_lines
--------------
Content for PAM auth. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_account_lines
-----------------
Content for PAM account. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_password_lines
------------------
Content for PAM password. If undef, parameter is set based on the OS version.

- *Default*: undef, default is set based on OS version

pam_session_lines
-----------------
Content for PAM session. If undef, parameter is set based on the OS version.

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

limits_d_dir
------------
Path to limits.d directory

- *Default*: '/etc/security/limits.d'

limits_d_dir_mode
-----------------
Mode for limits_d_dir.

- *Default*: '0750'

===

# pam::limits::fragment define
Places a fragment in $limits_d_dir directory

## Parameters for `pam::limits::fragment`
Source or list **must** be set.

source
------
String - Path to the fragment file, such as 'puppet:///modules/pam/limits.nproc'

- *Default*: 'UNSET'

list
----
Array of lines to add to the fragment file

===

# pam::service
Manage PAM file for specific service

## Usage
you can specify a hash for to manage the services in Hiera
<pre>
pam::services:
  "sudo":
    content : "auth     required       pam_unix2.so"
</pre>

## Paramteters for `pam::service`

pam_config_dir
--------------
Path to PAM files

- *Default*: '/etc/pam.d/'

content
-------
Content of the PAM file for the service

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

