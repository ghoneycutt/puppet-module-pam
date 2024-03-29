# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`pam`](#pam): This module manages PAM.
* [`pam::accesslogin`](#pam--accesslogin): Manage login access
See PAM_ACCESS(8)
* [`pam::faillock`](#pam--faillock): Manage faillock.conf
* [`pam::limits`](#pam--limits): Manage PAM limits.conf
* [`pam::pwquality`](#pam--pwquality): Manage pwquality.conf

### Defined types

* [`pam::limits::fragment`](#pam--limits--fragment): Places a fragment in $limits_d_dir directory One of the parameters `source`
or `list` **must** be set.
* [`pam::service`](#pam--service): Manage PAM file for specific service. The `pam::service` resource is

## Classes

### <a name="pam"></a>`pam`

This module manages PAM.

#### Examples

##### Declaring the class

```puppet
include pam
```

#### Parameters

The following parameters are available in the `pam` class:

* [`allowed_users`](#-pam--allowed_users)
* [`manage_accesslogin`](#-pam--manage_accesslogin)
* [`login_pam_access`](#-pam--login_pam_access)
* [`sshd_pam_access`](#-pam--sshd_pam_access)
* [`limits_fragments`](#-pam--limits_fragments)
* [`limits_fragments_hiera_merge`](#-pam--limits_fragments_hiera_merge)
* [`manage_faillock`](#-pam--manage_faillock)
* [`manage_pwquality`](#-pam--manage_pwquality)
* [`package_name`](#-pam--package_name)
* [`pam_conf_file`](#-pam--pam_conf_file)
* [`services`](#-pam--services)
* [`pam_d_login_oracle_options`](#-pam--pam_d_login_oracle_options)
* [`pam_d_login_path`](#-pam--pam_d_login_path)
* [`pam_d_login_owner`](#-pam--pam_d_login_owner)
* [`pam_d_login_group`](#-pam--pam_d_login_group)
* [`pam_d_login_mode`](#-pam--pam_d_login_mode)
* [`pam_d_login_template`](#-pam--pam_d_login_template)
* [`pam_d_sshd_path`](#-pam--pam_d_sshd_path)
* [`pam_d_sshd_owner`](#-pam--pam_d_sshd_owner)
* [`pam_d_sshd_group`](#-pam--pam_d_sshd_group)
* [`pam_d_sshd_mode`](#-pam--pam_d_sshd_mode)
* [`pam_d_sshd_template`](#-pam--pam_d_sshd_template)
* [`pam_sshd_auth_lines`](#-pam--pam_sshd_auth_lines)
* [`pam_sshd_account_lines`](#-pam--pam_sshd_account_lines)
* [`pam_sshd_password_lines`](#-pam--pam_sshd_password_lines)
* [`pam_sshd_session_lines`](#-pam--pam_sshd_session_lines)
* [`pam_auth_lines`](#-pam--pam_auth_lines)
* [`pam_account_lines`](#-pam--pam_account_lines)
* [`pam_password_lines`](#-pam--pam_password_lines)
* [`pam_session_lines`](#-pam--pam_session_lines)
* [`other_file`](#-pam--other_file)
* [`common_auth_file`](#-pam--common_auth_file)
* [`common_auth_pc_file`](#-pam--common_auth_pc_file)
* [`common_account_file`](#-pam--common_account_file)
* [`common_account_pc_file`](#-pam--common_account_pc_file)
* [`common_password_file`](#-pam--common_password_file)
* [`common_password_pc_file`](#-pam--common_password_pc_file)
* [`common_session_file`](#-pam--common_session_file)
* [`common_session_pc_file`](#-pam--common_session_pc_file)
* [`common_session_noninteractive_file`](#-pam--common_session_noninteractive_file)
* [`system_auth_file`](#-pam--system_auth_file)
* [`system_auth_ac_file`](#-pam--system_auth_ac_file)
* [`password_auth_file`](#-pam--password_auth_file)
* [`password_auth_ac_file`](#-pam--password_auth_ac_file)
* [`pam_password_auth_lines`](#-pam--pam_password_auth_lines)
* [`pam_password_account_lines`](#-pam--pam_password_account_lines)
* [`pam_password_password_lines`](#-pam--pam_password_password_lines)
* [`pam_password_session_lines`](#-pam--pam_password_session_lines)
* [`manage_nsswitch`](#-pam--manage_nsswitch)
* [`common_files`](#-pam--common_files)
* [`common_files_create_links`](#-pam--common_files_create_links)
* [`common_files_suffix`](#-pam--common_files_suffix)

##### <a name="-pam--allowed_users"></a>`allowed_users`

Data type: `Variant[Array, Hash, String]`

String, Array or Hash of strings and/or arrays to configure users and
origins in access.conf. The default allows the root user/group from origin
'ALL'.

Default value: `'root'`

##### <a name="-pam--manage_accesslogin"></a>`manage_accesslogin`

Data type: `Boolean`

Boolean to manage the inclusion of the pam::accesslogin class.
Can be useful if /etc/security/access.conf is managed externally.
Defaults to true.

Default value: `true`

##### <a name="-pam--login_pam_access"></a>`login_pam_access`

Data type: `Enum['absent', 'optional', 'required', 'requisite', 'sufficient']`

Control module to be used for pam_access.so for login. Valid values are
'required', 'requisite', 'sufficient', 'optional' and 'absent'.

Default value: `'required'`

##### <a name="-pam--sshd_pam_access"></a>`sshd_pam_access`

Data type: `Enum['absent', 'optional', 'required', 'requisite', 'sufficient']`

Control module to be used for pam_access.so for sshd. Valid values are
'required', 'requisite', 'sufficient', 'optional' and 'absent'.

Default value: `'required'`

##### <a name="-pam--limits_fragments"></a>`limits_fragments`

Data type: `Optional[Hash]`

Hash of fragments to pass to pam::limits::fragments

Default value: `undef`

##### <a name="-pam--limits_fragments_hiera_merge"></a>`limits_fragments_hiera_merge`

Data type: `Boolean`

Boolean to control merges of all found instances of pam::limits_fragments
in Hiera. This is useful for specifying fragments at different levels of
the hierarchy and having them all included in the catalog.

Default value: `false`

##### <a name="-pam--manage_faillock"></a>`manage_faillock`

Data type: `Boolean`

Controls whether to manage faillock.conf

Default value: `false`

##### <a name="-pam--manage_pwquality"></a>`manage_pwquality`

Data type: `Boolean`

Controls whether to manage pwquality.conf and pwquality.conf.d

Default value: `false`

##### <a name="-pam--package_name"></a>`package_name`

Data type: `Optional[Variant[Array, String]]`

String or Array of packages providing the pam functionality. If undef,
parameter is set based on the OS version.

Default value: `undef`

##### <a name="-pam--pam_conf_file"></a>`pam_conf_file`

Data type: `Stdlib::Absolutepath`

Absolute path to pam.conf.

Default value: `'/etc/pam.conf'`

##### <a name="-pam--services"></a>`services`

Data type: `Optional[Hash]`

Hash of pam::service entries to be created.

Default value: `undef`

##### <a name="-pam--pam_d_login_oracle_options"></a>`pam_d_login_oracle_options`

Data type: `Array`

Allow array of extra lines at the bottom of pam.d/login for oracle systems
on EL5.

Default value: `[]`

##### <a name="-pam--pam_d_login_path"></a>`pam_d_login_path`

Data type: `Stdlib::Absolutepath`

Absolute path to PAM login file.

Default value: `'/etc/pam.d/login'`

##### <a name="-pam--pam_d_login_owner"></a>`pam_d_login_owner`

Data type: `String`

Owner of $pam_d_login_path.

Default value: `'root'`

##### <a name="-pam--pam_d_login_group"></a>`pam_d_login_group`

Data type: `String`

Group of $pam_d_login_path.

Default value: `'root'`

##### <a name="-pam--pam_d_login_mode"></a>`pam_d_login_mode`

Data type: `Stdlib::Filemode`

Mode of $pam_d_login_path.

Default value: `'0644'`

##### <a name="-pam--pam_d_login_template"></a>`pam_d_login_template`

Data type: `Optional[String]`

Content template of $pam_d_login_path. If undef, parameter is set based on
the OS version.

Default value: `undef`

##### <a name="-pam--pam_d_sshd_path"></a>`pam_d_sshd_path`

Data type: `Stdlib::Absolutepath`

PAM sshd path.

Default value: `'/etc/pam.d/sshd'`

##### <a name="-pam--pam_d_sshd_owner"></a>`pam_d_sshd_owner`

Data type: `String`

Owner of $pam_d_sshd_path.

Default value: `'root'`

##### <a name="-pam--pam_d_sshd_group"></a>`pam_d_sshd_group`

Data type: `String`

Group of $pam_d_sshd_path.

Default value: `'root'`

##### <a name="-pam--pam_d_sshd_mode"></a>`pam_d_sshd_mode`

Data type: `Stdlib::Filemode`

Mode of $pam_d_sshd_path.

Default value: `'0644'`

##### <a name="-pam--pam_d_sshd_template"></a>`pam_d_sshd_template`

Data type: `Optional[String]`

Content template of $pam_d_sshd_path. If undef, parameter is set based on
the OS version. For cases where a full customization of the sshd PAM
configuration is required, set pam_d_sshd_template to use
pam/sshd.custom.erb that is provided with this module. pam/sshd.custom.erb
must be further configured with the parameters pam_sshd_auth_lines,
pam_sshd_account_lines, pam_sshd_password_lines and pam_sshd_session_lines.
Note that the pam_d_sshd_template parameter is a no-op on Solaris.

Default value: `undef`

##### <a name="-pam--pam_sshd_auth_lines"></a>`pam_sshd_auth_lines`

Data type: `Optional[Array]`

An ordered array of strings that define the content for PAM sshd auth.
This setting is required and only valid if pam_d_sshd_template is
configured to use the pam/sshd.custom.erb template.

Default value: `undef`

##### <a name="-pam--pam_sshd_account_lines"></a>`pam_sshd_account_lines`

Data type: `Optional[Array]`

An ordered array of strings that define the content for PAM sshd account.
This setting is required and only valid if pam_d_sshd_template is
configured to use the pam/sshd.custom.erb template.

Default value: `undef`

##### <a name="-pam--pam_sshd_password_lines"></a>`pam_sshd_password_lines`

Data type: `Optional[Array]`

An ordered array of strings that define the content for PAM sshd password.
This setting is required and only valid if pam_d_sshd_template is
configured to use the pam/sshd.custom.erb template.

Default value: `undef`

##### <a name="-pam--pam_sshd_session_lines"></a>`pam_sshd_session_lines`

Data type: `Optional[Array]`

An ordered array of strings that define the content for PAM sshd session.
This setting is required and only valid if pam_d_sshd_template is
configured to use the pam/sshd.custom.erb template.

Default value: `undef`

##### <a name="-pam--pam_auth_lines"></a>`pam_auth_lines`

Data type: `Optional[Array]`

An ordered array of strings that define the content for PAM auth. If
undef, parameter is set based on the OS version.

Default value: `undef`

##### <a name="-pam--pam_account_lines"></a>`pam_account_lines`

Data type: `Optional[Array]`

An ordered array of strings that define the content for PAM account. If
undef, parameter is set based on the OS version.

Default value: `undef`

##### <a name="-pam--pam_password_lines"></a>`pam_password_lines`

Data type: `Optional[Array]`

An ordered array of strings that define the content for PAM password. If
undef, parameter is set based on the OS version.

Default value: `undef`

##### <a name="-pam--pam_session_lines"></a>`pam_session_lines`

Data type: `Optional[Array]`

An ordered array of strings that define the content for PAM session. If
undef, parameter is set based on the OS version.

Default value: `undef`

##### <a name="-pam--other_file"></a>`other_file`

Data type: `Stdlib::Absolutepath`

Path to PAM other file. Used on Suse 9 and Solaris.

Default value: `'/etc/pam.d/other'`

##### <a name="-pam--common_auth_file"></a>`common_auth_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-auth file. Used on Debian/Ubuntu and Suse.

Default value: `'/etc/pam.d/common-auth'`

##### <a name="-pam--common_auth_pc_file"></a>`common_auth_pc_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-auth-pc file. Used on Suse.

Default value: `'/etc/pam.d/common-auth-pc'`

##### <a name="-pam--common_account_file"></a>`common_account_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-account file. Used on Suse.

Default value: `'/etc/pam.d/common-account'`

##### <a name="-pam--common_account_pc_file"></a>`common_account_pc_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-account-pc file. Used on Suse.

Default value: `'/etc/pam.d/common-account-pc'`

##### <a name="-pam--common_password_file"></a>`common_password_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-password file. Used on Suse.

Default value: `'/etc/pam.d/common-password'`

##### <a name="-pam--common_password_pc_file"></a>`common_password_pc_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-password-pc file. Used on Suse.

Default value: `'/etc/pam.d/common-password-pc'`

##### <a name="-pam--common_session_file"></a>`common_session_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-session file. Used on Suse.

Default value: `'/etc/pam.d/common-session'`

##### <a name="-pam--common_session_pc_file"></a>`common_session_pc_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-session-pc file. Used on Suse.

Default value: `'/etc/pam.d/common-session-pc'`

##### <a name="-pam--common_session_noninteractive_file"></a>`common_session_noninteractive_file`

Data type: `Stdlib::Absolutepath`

Path to PAM common-session-noninteractive file, which is the same as
common-session-pc used on Suse. Used on Ubuntu 12.04 LTS.

Default value: `'/etc/pam.d/common-session-noninteractive'`

##### <a name="-pam--system_auth_file"></a>`system_auth_file`

Data type: `Stdlib::Absolutepath`

Path to PAM system-auth file. Used on RedHat.

Default value: `'/etc/pam.d/system-auth'`

##### <a name="-pam--system_auth_ac_file"></a>`system_auth_ac_file`

Data type: `Stdlib::Absolutepath`

Path to PAM system-auth-ac file. Used on RedHat.

Default value: `'/etc/pam.d/system-auth-ac'`

##### <a name="-pam--password_auth_file"></a>`password_auth_file`

Data type: `Stdlib::Absolutepath`

Path to PAM password-auth file. Used on RedHat.

Default value: `'/etc/pam.d/password-auth'`

##### <a name="-pam--password_auth_ac_file"></a>`password_auth_ac_file`

Data type: `Stdlib::Absolutepath`

Path to PAM password-auth-ac file. Used on RedHat.

Default value: `'/etc/pam.d/password-auth-ac'`

##### <a name="-pam--pam_password_auth_lines"></a>`pam_password_auth_lines`

Data type: `Optional[Array]`

Array of lines used in content template of $password_auth_ac_file. If
undef, parameter is set based on defaults for the detected platform.

Default value: `undef`

##### <a name="-pam--pam_password_account_lines"></a>`pam_password_account_lines`

Data type: `Optional[Array]`

Array of lines used in content template of $password_auth_ac_file. If
undef, parameter is set based on defaults for the detected platform.

Default value: `undef`

##### <a name="-pam--pam_password_password_lines"></a>`pam_password_password_lines`

Data type: `Optional[Array]`

Array of lines used in content template of $password_auth_ac_file. If
undef, parameter is set based on defaults for the detected platform.

Default value: `undef`

##### <a name="-pam--pam_password_session_lines"></a>`pam_password_session_lines`

Data type: `Optional[Array]`

Array of lines used in content template of $password_auth_ac_file. If
undef, parameter is set based on defaults for the detected platform.

Default value: `undef`

##### <a name="-pam--manage_nsswitch"></a>`manage_nsswitch`

Data type: `Boolean`

Boolean to manage the inclusion of the nsswitch class.

Default value: `true`

##### <a name="-pam--common_files"></a>`common_files`

Data type: `Array`

Private, do not specify. Manage pam files where the entries match existing
template names. These common_files* parameters are used internally to
specify which files and names are needed. The data is coming out of Hiera
in `data/os/`.

Default value: `[]`

##### <a name="-pam--common_files_create_links"></a>`common_files_create_links`

Data type: `Boolean`

Private, do not specify. If true, then symlinks are created from the
suffixed files to the originals without the suffix.

Default value: `false`

##### <a name="-pam--common_files_suffix"></a>`common_files_suffix`

Data type: `Optional[String]`

Suffix added to the common_files entries for the filename.

Default value: `undef`

### <a name="pam--accesslogin"></a>`pam::accesslogin`

Manage login access
See PAM_ACCESS(8)

#### Examples

##### 

```puppet
This class is included by the pam class for platforms which use it.
```

#### Parameters

The following parameters are available in the `pam::accesslogin` class:

* [`access_conf_path`](#-pam--accesslogin--access_conf_path)
* [`access_conf_owner`](#-pam--accesslogin--access_conf_owner)
* [`access_conf_group`](#-pam--accesslogin--access_conf_group)
* [`access_conf_mode`](#-pam--accesslogin--access_conf_mode)
* [`access_conf_template`](#-pam--accesslogin--access_conf_template)
* [`allowed_users`](#-pam--accesslogin--allowed_users)

##### <a name="-pam--accesslogin--access_conf_path"></a>`access_conf_path`

Data type: `Stdlib::Absolutepath`

Path to access.conf.

Default value: `'/etc/security/access.conf'`

##### <a name="-pam--accesslogin--access_conf_owner"></a>`access_conf_owner`

Data type: `String`

Owner of access.conf.

Default value: `'root'`

##### <a name="-pam--accesslogin--access_conf_group"></a>`access_conf_group`

Data type: `String`

Group of access.conf.

Default value: `'root'`

##### <a name="-pam--accesslogin--access_conf_mode"></a>`access_conf_mode`

Data type: `Stdlib::Filemode`

Mode of access.conf.

Default value: `'0644'`

##### <a name="-pam--accesslogin--access_conf_template"></a>`access_conf_template`

Data type: `String`

Content template of access.conf.

Default value: `'pam/access.conf.erb'`

##### <a name="-pam--accesslogin--allowed_users"></a>`allowed_users`

Data type: `Variant[Array, Hash, String]`

String, Array or Hash of strings and/or arrays to configure users and
origins in access.conf. The default allows the root user/group from
origin 'ALL'.

Default value: `$pam::allowed_users`

### <a name="pam--faillock"></a>`pam::faillock`

Manage faillock.conf

#### Parameters

The following parameters are available in the `pam::faillock` class:

* [`config_file`](#-pam--faillock--config_file)
* [`config_file_owner`](#-pam--faillock--config_file_owner)
* [`config_file_group`](#-pam--faillock--config_file_group)
* [`config_file_mode`](#-pam--faillock--config_file_mode)
* [`config_file_template`](#-pam--faillock--config_file_template)
* [`config_file_source`](#-pam--faillock--config_file_source)
* [`dir`](#-pam--faillock--dir)
* [`audit_enabled`](#-pam--faillock--audit_enabled)
* [`silent`](#-pam--faillock--silent)
* [`no_log_info`](#-pam--faillock--no_log_info)
* [`local_users_only`](#-pam--faillock--local_users_only)
* [`deny`](#-pam--faillock--deny)
* [`fail_interval`](#-pam--faillock--fail_interval)
* [`unlock_time`](#-pam--faillock--unlock_time)
* [`even_deny_root`](#-pam--faillock--even_deny_root)
* [`root_unlock_time`](#-pam--faillock--root_unlock_time)
* [`admin_group`](#-pam--faillock--admin_group)

##### <a name="-pam--faillock--config_file"></a>`config_file`

Data type: `Stdlib::Absolutepath`

The faillock config path

Default value: `'/etc/security/faillock.conf'`

##### <a name="-pam--faillock--config_file_owner"></a>`config_file_owner`

Data type: `String[1]`

The faillock config owner

Default value: `'root'`

##### <a name="-pam--faillock--config_file_group"></a>`config_file_group`

Data type: `String[1]`

The faillock config group

Default value: `'root'`

##### <a name="-pam--faillock--config_file_mode"></a>`config_file_mode`

Data type: `Stdlib::Filemode`

The faillock config mode

Default value: `'0644'`

##### <a name="-pam--faillock--config_file_template"></a>`config_file_template`

Data type: `String[1]`

The faillock config template

Default value: `'pam/faillock.conf.erb'`

##### <a name="-pam--faillock--config_file_source"></a>`config_file_source`

Data type: `Optional[Stdlib::Filesource]`

The faillock config source

Default value: `undef`

##### <a name="-pam--faillock--dir"></a>`dir`

Data type: `Stdlib::Absolutepath`

The faillock 'dir' config option

Default value: `'/var/run/faillock'`

##### <a name="-pam--faillock--audit_enabled"></a>`audit_enabled`

Data type: `Optional[Boolean]`

The faillock 'audit' config option

Default value: `undef`

##### <a name="-pam--faillock--silent"></a>`silent`

Data type: `Optional[Boolean]`

The faillock 'silent' config option

Default value: `undef`

##### <a name="-pam--faillock--no_log_info"></a>`no_log_info`

Data type: `Optional[Boolean]`

The faillock 'no_log_info' config option

Default value: `undef`

##### <a name="-pam--faillock--local_users_only"></a>`local_users_only`

Data type: `Optional[Boolean]`

The faillock 'local_users_only' config option

Default value: `undef`

##### <a name="-pam--faillock--deny"></a>`deny`

Data type: `Integer[0]`

The faillock 'deny' config option

Default value: `3`

##### <a name="-pam--faillock--fail_interval"></a>`fail_interval`

Data type: `Integer[0]`

The faillock 'fail_interval' config option

Default value: `900`

##### <a name="-pam--faillock--unlock_time"></a>`unlock_time`

Data type: `Integer[0]`

The faillock 'unlock_time' config option

Default value: `600`

##### <a name="-pam--faillock--even_deny_root"></a>`even_deny_root`

Data type: `Optional[Boolean]`

The faillock 'even_deny_root' config option

Default value: `undef`

##### <a name="-pam--faillock--root_unlock_time"></a>`root_unlock_time`

Data type: `Integer[0]`

The faillock 'root_unlock_time' config option

Default value: `$unlock_time`

##### <a name="-pam--faillock--admin_group"></a>`admin_group`

Data type: `Optional[String[1]]`

The faillock 'admin_group' config option

Default value: `undef`

### <a name="pam--limits"></a>`pam::limits`

Manage PAM limits.conf

#### Examples

##### 

```puppet
This class is included by the pam class for platforms which use it.
```

#### Parameters

The following parameters are available in the `pam::limits` class:

* [`config_file`](#-pam--limits--config_file)
* [`config_file_mode`](#-pam--limits--config_file_mode)
* [`config_file_lines`](#-pam--limits--config_file_lines)
* [`config_file_source`](#-pam--limits--config_file_source)
* [`limits_d_dir`](#-pam--limits--limits_d_dir)
* [`limits_d_dir_mode`](#-pam--limits--limits_d_dir_mode)
* [`purge_limits_d_dir`](#-pam--limits--purge_limits_d_dir)
* [`purge_limits_d_dir_ignore`](#-pam--limits--purge_limits_d_dir_ignore)

##### <a name="-pam--limits--config_file"></a>`config_file`

Data type: `Stdlib::Absolutepath`

Path to limits.conf.

Default value: `'/etc/security/limits.conf'`

##### <a name="-pam--limits--config_file_mode"></a>`config_file_mode`

Data type: `Stdlib::Filemode`

Mode for config_file.

Default value: `'0640'`

##### <a name="-pam--limits--config_file_lines"></a>`config_file_lines`

Data type: `Optional[Array]`

Ordered array of limits that should be placed into limits.conf. Useful for
Suse 10 which does not use limits.d.

Default value: `undef`

##### <a name="-pam--limits--config_file_source"></a>`config_file_source`

Data type: `Optional[String]`

String with source path to a limits.conf

Default value: `undef`

##### <a name="-pam--limits--limits_d_dir"></a>`limits_d_dir`

Data type: `Stdlib::Absolutepath`

Path to limits.d directory.

Default value: `'/etc/security/limits.d'`

##### <a name="-pam--limits--limits_d_dir_mode"></a>`limits_d_dir_mode`

Data type: `Stdlib::Filemode`

Mode for limits_d_dir.

Default value: `'0750'`

##### <a name="-pam--limits--purge_limits_d_dir"></a>`purge_limits_d_dir`

Data type: `Boolean`

Boolean to purge the limits.d directory.

Default value: `false`

##### <a name="-pam--limits--purge_limits_d_dir_ignore"></a>`purge_limits_d_dir_ignore`

Data type: `Optional[Variant[String[1], Array[String[1]]]]`

A glob or array of file names to ignore when purging limits.d

Default value: `undef`

### <a name="pam--pwquality"></a>`pam::pwquality`

Manage pwquality.conf

#### Examples

##### 

```puppet
This class is included by the pam class for platforms which use it.
```

#### Parameters

The following parameters are available in the `pam::pwquality` class:

* [`config_file`](#-pam--pwquality--config_file)
* [`config_file_owner`](#-pam--pwquality--config_file_owner)
* [`config_file_group`](#-pam--pwquality--config_file_group)
* [`config_file_mode`](#-pam--pwquality--config_file_mode)
* [`config_file_source`](#-pam--pwquality--config_file_source)
* [`config_file_template`](#-pam--pwquality--config_file_template)
* [`config_d_dir`](#-pam--pwquality--config_d_dir)
* [`config_d_dir_owner`](#-pam--pwquality--config_d_dir_owner)
* [`config_d_dir_group`](#-pam--pwquality--config_d_dir_group)
* [`config_d_dir_mode`](#-pam--pwquality--config_d_dir_mode)
* [`purge_config_d_dir`](#-pam--pwquality--purge_config_d_dir)
* [`purge_config_d_dir_ignore`](#-pam--pwquality--purge_config_d_dir_ignore)
* [`difok`](#-pam--pwquality--difok)
* [`minlen`](#-pam--pwquality--minlen)
* [`dcredit`](#-pam--pwquality--dcredit)
* [`ucredit`](#-pam--pwquality--ucredit)
* [`lcredit`](#-pam--pwquality--lcredit)
* [`ocredit`](#-pam--pwquality--ocredit)
* [`minclass`](#-pam--pwquality--minclass)
* [`maxrepeat`](#-pam--pwquality--maxrepeat)
* [`maxsequence`](#-pam--pwquality--maxsequence)
* [`maxclassrepeat`](#-pam--pwquality--maxclassrepeat)
* [`gecoscheck`](#-pam--pwquality--gecoscheck)
* [`dictcheck`](#-pam--pwquality--dictcheck)
* [`usercheck`](#-pam--pwquality--usercheck)
* [`usersubstr`](#-pam--pwquality--usersubstr)
* [`enforcing`](#-pam--pwquality--enforcing)
* [`badwords`](#-pam--pwquality--badwords)
* [`dictpath`](#-pam--pwquality--dictpath)
* [`retry`](#-pam--pwquality--retry)
* [`enforce_for_root`](#-pam--pwquality--enforce_for_root)
* [`local_users_only`](#-pam--pwquality--local_users_only)

##### <a name="-pam--pwquality--config_file"></a>`config_file`

Data type: `Stdlib::Absolutepath`

Path to pwquality.conf.

Default value: `'/etc/security/pwquality.conf'`

##### <a name="-pam--pwquality--config_file_owner"></a>`config_file_owner`

Data type: `String[1]`

Owner for pwquality.conf

Default value: `'root'`

##### <a name="-pam--pwquality--config_file_group"></a>`config_file_group`

Data type: `String[1]`

Group for pwquality.conf

Default value: `'root'`

##### <a name="-pam--pwquality--config_file_mode"></a>`config_file_mode`

Data type: `Stdlib::Filemode`

Mode for config_file.

Default value: `'0644'`

##### <a name="-pam--pwquality--config_file_source"></a>`config_file_source`

Data type: `Optional[Stdlib::Filesource]`

String with source path to a pwquality.conf

Default value: `undef`

##### <a name="-pam--pwquality--config_file_template"></a>`config_file_template`

Data type: `String[1]`

Template to render pwquality.conf

Default value: `'pam/pwquality.conf.erb'`

##### <a name="-pam--pwquality--config_d_dir"></a>`config_d_dir`

Data type: `Stdlib::Absolutepath`

Path to pwquality.conf.d directory.

Default value: `'/etc/security/pwquality.conf.d'`

##### <a name="-pam--pwquality--config_d_dir_owner"></a>`config_d_dir_owner`

Data type: `String[1]`

Owner for pwquality.conf.d

Default value: `'root'`

##### <a name="-pam--pwquality--config_d_dir_group"></a>`config_d_dir_group`

Data type: `String[1]`

Group for pwquality.conf.d

Default value: `'root'`

##### <a name="-pam--pwquality--config_d_dir_mode"></a>`config_d_dir_mode`

Data type: `Stdlib::Filemode`

Mode for pwquality.conf.d

Default value: `'0755'`

##### <a name="-pam--pwquality--purge_config_d_dir"></a>`purge_config_d_dir`

Data type: `Boolean`

Boolean to purge the pwquality.conf.d directory.

Default value: `true`

##### <a name="-pam--pwquality--purge_config_d_dir_ignore"></a>`purge_config_d_dir_ignore`

Data type: `Optional[Variant[String[1], Array[String[1]]]]`

A glob or array of file names to ignore when purging pwquality.conf.d

Default value: `undef`

##### <a name="-pam--pwquality--difok"></a>`difok`

Data type: `Integer[0]`

The pwquality.conf 'difok' option

Default value: `1`

##### <a name="-pam--pwquality--minlen"></a>`minlen`

Data type: `Integer[6]`

The pwquality.conf 'minlen' option

Default value: `8`

##### <a name="-pam--pwquality--dcredit"></a>`dcredit`

Data type: `Integer`

The pwquality.conf 'dcredit' option

Default value: `0`

##### <a name="-pam--pwquality--ucredit"></a>`ucredit`

Data type: `Integer`

The pwquality.conf 'ucredit' option

Default value: `0`

##### <a name="-pam--pwquality--lcredit"></a>`lcredit`

Data type: `Integer`

The pwquality.conf 'lcredit' option

Default value: `0`

##### <a name="-pam--pwquality--ocredit"></a>`ocredit`

Data type: `Integer`

The pwquality.conf 'ocredit' option

Default value: `0`

##### <a name="-pam--pwquality--minclass"></a>`minclass`

Data type: `Integer[0]`

The pwquality.conf 'minclass' option

Default value: `0`

##### <a name="-pam--pwquality--maxrepeat"></a>`maxrepeat`

Data type: `Integer[0]`

The pwquality.conf 'maxrepeat' option

Default value: `0`

##### <a name="-pam--pwquality--maxsequence"></a>`maxsequence`

Data type: `Integer[0]`

The pwquality.conf 'maxsequence' option

Default value: `0`

##### <a name="-pam--pwquality--maxclassrepeat"></a>`maxclassrepeat`

Data type: `Integer[0]`

The pwquality.conf 'maxclassrepeat' option

Default value: `0`

##### <a name="-pam--pwquality--gecoscheck"></a>`gecoscheck`

Data type: `Integer[0]`

The pwquality.conf 'gecoscheck' option

Default value: `0`

##### <a name="-pam--pwquality--dictcheck"></a>`dictcheck`

Data type: `Integer[0]`

The pwquality.conf 'dictcheck' option

Default value: `1`

##### <a name="-pam--pwquality--usercheck"></a>`usercheck`

Data type: `Integer[0]`

The pwquality.conf 'usercheck' option

Default value: `1`

##### <a name="-pam--pwquality--usersubstr"></a>`usersubstr`

Data type: `Integer[0]`

The pwquality.conf 'usersubstr' option

Default value: `0`

##### <a name="-pam--pwquality--enforcing"></a>`enforcing`

Data type: `Integer[0]`

The pwquality.conf 'enforcing' option

Default value: `1`

##### <a name="-pam--pwquality--badwords"></a>`badwords`

Data type: `Optional[Array[String[1]]]`

The pwquality.conf 'badwords' option

Default value: `undef`

##### <a name="-pam--pwquality--dictpath"></a>`dictpath`

Data type: `Optional[Stdlib::Absolutepath]`

The pwquality.conf 'dictpath' option

Default value: `undef`

##### <a name="-pam--pwquality--retry"></a>`retry`

Data type: `Integer[0]`

The pwquality.conf 'retry' option

Default value: `1`

##### <a name="-pam--pwquality--enforce_for_root"></a>`enforce_for_root`

Data type: `Optional[Boolean]`

The pwquality.conf 'enforce_for_root' option

Default value: `undef`

##### <a name="-pam--pwquality--local_users_only"></a>`local_users_only`

Data type: `Optional[Boolean]`

The pwquality.conf 'local_users_only' option

Default value: `undef`

## Defined types

### <a name="pam--limits--fragment"></a>`pam::limits::fragment`

Places a fragment in $limits_d_dir directory One of the parameters `source`
or `list` **must** be set.

#### Examples

##### 

```puppet
pam::limits::fragment { 'nproc':
  source => 'puppet:///modules/pam/limits.nproc',
}
```

#### Parameters

The following parameters are available in the `pam::limits::fragment` defined type:

* [`ensure`](#-pam--limits--fragment--ensure)
* [`source`](#-pam--limits--fragment--source)
* [`list`](#-pam--limits--fragment--list)

##### <a name="-pam--limits--fragment--ensure"></a>`ensure`

Data type: `Enum['file', 'present', 'absent']`

Ensure attribute for the fragment file.

Default value: `'file'`

##### <a name="-pam--limits--fragment--source"></a>`source`

Data type: `Optional[String]`

Path to the fragment file, such as 'puppet:///modules/pam/limits.nproc'

Default value: `undef`

##### <a name="-pam--limits--fragment--list"></a>`list`

Data type: `Optional[Array]`

Array of lines to add to the fragment file.

Default value: `undef`

### <a name="pam--service"></a>`pam::service`

reversible, so that any service that Puppet has locked using PAM can be
unlocked by setting the resource ensure to absent and waiting for the next
puppet run.

#### Examples

##### 

```puppet
pam::service { 'sudo':
  content => 'auth     required       pam_unix2.so',
}
```

#### Parameters

The following parameters are available in the `pam::service` defined type:

* [`ensure`](#-pam--service--ensure)
* [`pam_config_dir`](#-pam--service--pam_config_dir)
* [`content`](#-pam--service--content)
* [`lines`](#-pam--service--lines)

##### <a name="-pam--service--ensure"></a>`ensure`

Data type: `Enum['present', 'absent']`

Specifies if a PAM service file should (`present`) or should not (`absent`)
exist. The default is set to 'present'

Default value: `'present'`

##### <a name="-pam--service--pam_config_dir"></a>`pam_config_dir`

Data type: `Stdlib::Absolutepath`

Path to PAM files.

Default value: `'/etc/pam.d'`

##### <a name="-pam--service--content"></a>`content`

Data type: `Optional[String]`

Content of the PAM file for the service. The `content` and `lines`
parameters are mutually exclusive. Not setting either of these parameters
will result in an empty service definition file.

Default value: `undef`

##### <a name="-pam--service--lines"></a>`lines`

Data type: `Optional[Array]`

Provides content for the PAM service file as an array of lines. The
`content` and `lines` parameters are mutually exclusive. Not setting either
of these parameters will result in an empty service definition file.

Default value: `undef`

