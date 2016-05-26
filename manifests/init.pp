# == Class: pam
#
# This module manages bits around PAM.
#
class pam (
  $allowed_users                       = 'root',
  $login_pam_access                    = 'required',
  $sshd_pam_access                     = 'required',
  $ensure_vas                          = 'absent',
  $package_name                        = undef,
  $pam_conf_file                       = '/etc/pam.conf',
  $services                            = undef,
  $limits_fragments                    = undef,
  $limits_fragments_hiera_merge        = false,
  $pam_d_login_oracle_options          = 'UNSET',
  $pam_d_login_path                    = '/etc/pam.d/login',
  $pam_d_login_owner                   = 'root',
  $pam_d_login_group                   = 'root',
  $pam_d_login_mode                    = '0644',
  $pam_d_login_template                = undef,
  $pam_d_sshd_path                     = '/etc/pam.d/sshd',
  $pam_d_sshd_owner                    = 'root',
  $pam_d_sshd_group                    = 'root',
  $pam_d_sshd_mode                     = '0644',
  $pam_d_sshd_template                 = undef,
  $pam_sshd_auth_lines                 = undef,
  $pam_sshd_account_lines              = undef,
  $pam_sshd_password_lines             = undef,
  $pam_sshd_session_lines              = undef,
  $pam_auth_lines                      = undef,
  $pam_account_lines                   = undef,
  $pam_password_lines                  = undef,
  $pam_session_lines                   = undef,
  $pam_d_other_file                    = '/etc/pam.d/other',
  $common_auth_file                    = '/etc/pam.d/common-auth',
  $common_auth_pc_file                 = '/etc/pam.d/common-auth-pc',
  $common_account_file                 = '/etc/pam.d/common-account',
  $common_account_pc_file              = '/etc/pam.d/common-account-pc',
  $common_password_file                = '/etc/pam.d/common-password',
  $common_password_pc_file             = '/etc/pam.d/common-password-pc',
  $common_session_file                 = '/etc/pam.d/common-session',
  $common_session_pc_file              = '/etc/pam.d/common-session-pc',
  $common_session_noninteractive_file  = '/etc/pam.d/common-session-noninteractive',
  $system_auth_file                    = '/etc/pam.d/system-auth',
  $system_auth_ac_file                 = '/etc/pam.d/system-auth-ac',
  $password_auth_file                  = '/etc/pam.d/password-auth',
  $password_auth_ac_file               = '/etc/pam.d/password-auth-ac',
  $pam_password_auth_lines             = undef,
  $pam_password_account_lines          = undef,
  $pam_password_password_lines         = undef,
  $pam_password_session_lines          = undef,
  $system_auth_ac_auth_lines           = undef,
  $system_auth_ac_account_lines        = undef,
  $system_auth_ac_password_lines       = undef,
  $system_auth_ac_session_lines        = undef,
  $vas_major_version                   = '4',
) {

  include ::nsswitch

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '5': {
          $default_pam_d_login_template = 'pam/login.el5.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.el5.erb'
          $default_package_name         = [
            'pam',
            'util-linux',
          ]

          if $ensure_vas == 'present' {
            case $vas_major_version {
              '3': {
                $default_pam_auth_lines = [
                  'auth        required      pam_env.so',
                  'auth        sufficient    pam_vas3.so show_lockout_msg get_nonvas_pass store_creds',
                  'auth        requisite     pam_vas3.so echo_return',
                  'auth        sufficient    pam_unix.so nullok try_first_pass use_first_pass',
                  'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
                  'auth        required      pam_deny.so',
                ]
              }
              '4': {
                $default_pam_auth_lines = [
                  'auth        required      pam_env.so',
                  'auth        sufficient    pam_vas3.so show_lockout_msg get_nonvas_pass',
                  'auth        requisite     pam_vas3.so echo_return',
                  'auth        sufficient    pam_unix.so nullok try_first_pass use_first_pass',
                  'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
                  'auth        required      pam_deny.so',
                ]
              }
              default: {
                fail("Pam is only supported with vas_major_version 3 or 4. Your vas_major_version is <${vas_major_version}>.")
              }
            }

            $default_pam_account_lines = [
              'account     sufficient    pam_vas3.so',
              'account     requisite     pam_vas3.so echo_return',
              'account     required      pam_unix.so',
              'account     sufficient    pam_succeed_if.so uid < 500 quiet',
              'account     required      pam_permit.so',
            ]

            $default_pam_password_lines = [
              'password    sufficient    pam_vas3.so',
              'password    requisite     pam_vas3.so echo_return',
              'password    requisite     pam_cracklib.so try_first_pass retry=3 type=',
              'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password    required      pam_deny.so',
            ]

            $default_pam_session_lines = [
              'session     optional      pam_keyinit.so revoke',
              'session     required      pam_limits.so',
              'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
              'session     required      pam_vas3.so show_lockout_msg',
              'session     requisite     pam_vas3.so echo_return',
              'session     required      pam_unix.so',
            ]
          } else {
            $default_pam_auth_lines = [
              'auth        required      pam_env.so',
              'auth        sufficient    pam_unix.so nullok try_first_pass',
              'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
              'auth        required      pam_deny.so',
            ]

            $default_pam_account_lines = [
              'account     required      pam_unix.so',
              'account     sufficient    pam_succeed_if.so uid < 500 quiet',
              'account     required      pam_permit.so',
            ]

            $default_pam_password_lines = [
              'password    requisite     pam_cracklib.so try_first_pass retry=3',
              'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password    required      pam_deny.so',
            ]

            $default_pam_session_lines = [
              'session     optional      pam_keyinit.so revoke',
              'session     required      pam_limits.so',
              'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
              'session     required      pam_unix.so',
            ]
          }
        }
        '6': {
          $default_pam_d_login_template = 'pam/login.el6.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.el6.erb'
          $default_package_name         = 'pam'

          if $ensure_vas == 'present' {
            case $vas_major_version {
              '3': {
                $default_pam_auth_lines = [
                  'auth        required      pam_env.so',
                  'auth        sufficient    pam_vas3.so show_lockout_msg get_nonvas_pass store_creds',
                  'auth        requisite     pam_vas3.so echo_return',
                  'auth        sufficient    pam_unix.so nullok try_first_pass use_first_pass',
                  'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
                  'auth        required      pam_deny.so',
                ]
                $default_pam_password_auth_lines = [
                  'auth    required        pam_env.so',
                  'auth    sufficient      pam_vas3.so create_homedir get_nonvas_pass',
                  'auth    requisite       pam_vas3.so echo_return',
                  'auth    sufficient      pam_unix.so nullok try_first_pass use_first_pass',
                  'auth    requisite       pam_succeed_if.so uid >= 500 quiet',
                  'auth    required        pam_deny.so',
                ]
              }
              '4': {
                $default_pam_auth_lines = [
                  'auth        required      pam_env.so',
                  'auth        sufficient    pam_vas3.so show_lockout_msg get_nonvas_pass',
                  'auth        requisite     pam_vas3.so echo_return',
                  'auth        sufficient    pam_unix.so nullok try_first_pass use_first_pass',
                  'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
                  'auth        required      pam_deny.so',
                ]
                $default_pam_password_auth_lines = [
                  'auth    required        pam_env.so',
                  'auth    sufficient      pam_vas3.so create_homedir get_nonvas_pass',
                  'auth    requisite       pam_vas3.so echo_return',
                  'auth    sufficient      pam_unix.so nullok try_first_pass use_first_pass',
                  'auth    requisite       pam_succeed_if.so uid >= 500 quiet',
                  'auth    required        pam_deny.so',
                ]
              }
              default: {
                fail("Pam is only supported with vas_major_version 3 or 4. Your vas_major_version is <${vas_major_version}>.")
              }
            }

            $default_pam_account_lines = [
              'account     sufficient    pam_vas3.so',
              'account     requisite     pam_vas3.so echo_return',
              'account     required      pam_unix.so',
              'account     sufficient    pam_localuser.so',
              'account     sufficient    pam_succeed_if.so uid < 500 quiet',
              'account     required      pam_permit.so',
            ]

            $default_pam_password_lines = [
              'password    sufficient    pam_vas3.so',
              'password    requisite     pam_vas3.so echo_return',
              'password    requisite     pam_cracklib.so try_first_pass retry=3 type=',
              'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password    required      pam_deny.so',
            ]

            $default_pam_session_lines = [
              'session     optional      pam_keyinit.so revoke',
              'session     required      pam_limits.so',
              'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
              'session     required      pam_vas3.so show_lockout_msg',
              'session     requisite     pam_vas3.so echo_return',
              'session     required      pam_unix.so',
            ]
            $default_pam_password_account_lines = [
              'account sufficient      pam_vas3.so',
              'account requisite       pam_vas3.so echo_return',
              'account required        pam_unix.so',
              'account sufficient      pam_localuser.so',
              'account sufficient      pam_succeed_if.so uid < 500 quiet',
              'account required        pam_permit.so',
            ]

            $default_pam_password_password_lines = [
              'password        sufficient      pam_vas3.so',
              'password        requisite       pam_vas3.so echo_return',
              'password        requisite       pam_cracklib.so try_first_pass retry=3 type=',
              'password        sufficient      pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password        required        pam_deny.so',
            ]

            $default_pam_password_session_lines = [
              'session optional        pam_keyinit.so revoke',
              'session required        pam_limits.so',
              'session [success=1 default=ignore]      pam_succeed_if.so service in crond quiet use_uid',
              'session required        pam_vas3.so create_homedir',
              'session requisite       pam_vas3.so echo_return',
              'session required        pam_unix.so',
            ]

          } else {
            $default_pam_auth_lines = [
              'auth        required      pam_env.so',
              'auth        sufficient    pam_fprintd.so',
              'auth        sufficient    pam_unix.so nullok try_first_pass',
              'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
              'auth        required      pam_deny.so',
            ]

            $default_pam_password_auth_lines = [
              'auth        required      pam_env.so',
              'auth        sufficient    pam_unix.so nullok try_first_pass',
              'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
              'auth        required      pam_deny.so',
            ]

            $default_pam_account_lines = [
              'account     required      pam_unix.so',
              'account     sufficient    pam_localuser.so',
              'account     sufficient    pam_succeed_if.so uid < 500 quiet',
              'account     required      pam_permit.so',
            ]

            $default_pam_password_lines = [
              'password    requisite     pam_cracklib.so try_first_pass retry=3 type=',
              'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password    required      pam_deny.so',
            ]

            $default_pam_session_lines = [
              'session     optional      pam_keyinit.so revoke',
              'session     required      pam_limits.so',
              'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
              'session     required      pam_unix.so',
            ]
            $default_pam_password_account_lines = [
              'account     required      pam_unix.so',
              'account     sufficient    pam_localuser.so',
              'account     sufficient    pam_succeed_if.so uid < 500 quiet',
              'account     required      pam_permit.so',
            ]

            $default_pam_password_password_lines = [
              'password    requisite     pam_cracklib.so try_first_pass retry=3 type=',
              'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password    required      pam_deny.so',
            ]

            $default_pam_password_session_lines = [
              'session     optional      pam_keyinit.so revoke',
              'session     required      pam_limits.so',
              'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
              'session     required      pam_unix.so',
            ]
          }
        }
        '7': {
          $default_pam_d_login_template = 'pam/login.el7.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.el7.erb'
          $default_package_name         = 'pam'

          if $ensure_vas == 'present' {
            case $vas_major_version {
              '4': {
                $default_pam_auth_lines = [
                  'auth        required      pam_env.so',
                  'auth        sufficient    pam_vas3.so show_lockout_msg get_nonvas_pass',
                  'auth        requisite     pam_vas3.so echo_return',
                  'auth        sufficient    pam_unix.so nullok try_first_pass use_first_pass',
                  'auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success',
                  'auth        required      pam_deny.so',
                ]
                $default_pam_password_auth_lines = [
                  'auth    required        pam_env.so',
                  'auth    sufficient      pam_vas3.so create_homedir get_nonvas_pass',
                  'auth    requisite       pam_vas3.so echo_return',
                  'auth    sufficient      pam_unix.so nullok try_first_pass use_first_pass',
                  'auth    requisite       pam_succeed_if.so uid >= 1000 quiet_success',
                  'auth    required        pam_deny.so',
                ]
              }
              default: {
                fail("Pam is only supported with vas_major_version 4 on EL7. Your vas_major_version is <${vas_major_version}>.")
              }
            }

            $default_pam_account_lines = [
              'account     sufficient    pam_vas3.so',
              'account     requisite     pam_vas3.so echo_return',
              'account     required      pam_unix.so',
              'account     sufficient    pam_localuser.so',
              'account     sufficient    pam_succeed_if.so uid < 1000 quiet',
              'account     required      pam_permit.so',
            ]

            $default_pam_password_lines = [
              'password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=',
              'password    sufficient    pam_vas3.so',
              'password    requisite     pam_vas3.so echo_return',
              'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password    required      pam_deny.so',
            ]

            $default_pam_session_lines = [
              'session     optional      pam_keyinit.so revoke',
              'session     required      pam_limits.so',
              '-session    optional      pam_systemd.so',
              'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
              'session     required      pam_vas3.so show_lockout_msg',
              'session     requisite     pam_vas3.so echo_return',
              'session     required      pam_unix.so',
            ]
            $default_pam_password_account_lines = [
              'account sufficient      pam_vas3.so',
              'account requisite       pam_vas3.so echo_return',
              'account required        pam_unix.so',
              'account sufficient      pam_localuser.so',
              'account sufficient      pam_succeed_if.so uid < 1000 quiet',
              'account required        pam_permit.so',
            ]

            $default_pam_password_password_lines = [
              'password        requisite       pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=',
              'password        sufficient      pam_vas3.so',
              'password        requisite       pam_vas3.so echo_return',
              'password        sufficient      pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password        required        pam_deny.so',
            ]

            $default_pam_password_session_lines = [
              'session optional        pam_keyinit.so revoke',
              'session required        pam_limits.so',
              '-session        optional        pam_systemd.so',
              'session [success=1 default=ignore]      pam_succeed_if.so service in crond quiet use_uid',
              'session required        pam_vas3.so create_homedir',
              'session requisite       pam_vas3.so echo_return',
              'session required        pam_unix.so',
            ]
          } else {
            $default_pam_auth_lines = [
              'auth        required      pam_env.so',
              'auth        sufficient    pam_fprintd.so',
              'auth        sufficient    pam_unix.so nullok try_first_pass',
              'auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success',
              'auth        required      pam_deny.so',
            ]

            $default_pam_password_auth_lines = [
              'auth        required      pam_env.so',
              'auth        sufficient    pam_unix.so nullok try_first_pass',
              'auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success',
              'auth        required      pam_deny.so',
            ]

            $default_pam_account_lines = [
              'account     required      pam_unix.so',
              'account     sufficient    pam_localuser.so',
              'account     sufficient    pam_succeed_if.so uid < 1000 quiet',
              'account     required      pam_permit.so',
            ]

            $default_pam_password_lines = [
              'password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=',
              'password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok',
              'password    required      pam_deny.so',
            ]

            $default_pam_session_lines = [
              'session     optional      pam_keyinit.so revoke',
              'session     required      pam_limits.so',
              '-session    optional      pam_systemd.so',
              'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
              'session     required      pam_unix.so',
            ]
            $default_pam_password_account_lines = [
              'account     required      pam_unix.so',
              'account     sufficient    pam_localuser.so',
              'account     sufficient    pam_succeed_if.so uid < 1000 quiet',
              'account     required      pam_permit.so',
            ]

            $default_pam_password_password_lines = [
              'password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=',
              'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
              'password    required      pam_deny.so',
            ]
            $default_pam_password_session_lines = [
              'session     optional      pam_keyinit.so revoke',
              'session     required      pam_limits.so',
              '-session     optional      pam_systemd.so',
              'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
              'session     required      pam_unix.so',
            ]
          }
        }
        default: {
          fail("Pam is only supported on EL 5, 6 and 7. Your operatingsystemmajrelease is identified as <${::operatingsystemmajrelease}>.")
        }
      }
    }
    'Suse': {
      case $::lsbmajdistrelease {
        '9': {
          $default_pam_d_login_template = 'pam/login.suse9.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.suse9.erb'
          $default_package_name         = [ 'pam', 'pam-modules' ]

          $default_pam_auth_lines = [
            'auth  required  pam_warn.so',
            'auth  required  pam_unix2.so',
          ]

          $default_pam_account_lines = [
            'account  required  pam_warn.so',
            'account  required  pam_unix2.so',
          ]

          $default_pam_password_lines = [
            'password  required  pam_warn.so',
            'password  required  pam_pwcheck.so use_cracklib',
          ]

          $default_pam_session_lines = [
            'session  required  pam_warn.so',
            'session  required  pam_unix2.so debug',
          ]
        }

        '10': {
          $default_pam_d_login_template = 'pam/login.suse10.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.suse10.erb'
          $default_package_name         = 'pam'

          if $ensure_vas == 'present' {
            $default_pam_auth_lines = [
              'auth  required    pam_env.so',
              'auth  sufficient  pam_vas3.so show_lockout_msg get_nonvas_pass store_creds',
              'auth  requisite   pam_vas3.so echo_return',
              'auth  required    pam_unix2.so use_first_pass',
            ]

            $default_pam_account_lines = [
              'account  sufficient  pam_vas3.so',
              'account  requisite   pam_vas3.so echo_return',
              'account  required    pam_unix2.so',
            ]

            $default_pam_password_lines = [
              'password  sufficient  pam_vas3.so',
              'password  requisite   pam_vas3.so echo_return',
              'password  requisite   pam_pwcheck.so nullok',
              'password  required    pam_unix2.so use_authtok nullok',
            ]

            $default_pam_session_lines = [
              'session  required   pam_limits.so',
              'session  required   pam_vas3.so',
              'session  requisite  pam_vas3.so echo_return',
              'session  required   pam_unix2.so',
            ]

          } else {

            $default_pam_auth_lines = [
              'auth  required  pam_env.so',
              'auth  required  pam_unix2.so',
            ]

            $default_pam_account_lines = [
              'account  required  pam_unix2.so',
            ]

            $default_pam_password_lines = [
              'password  required  pam_pwcheck.so nullok',
              'password  required  pam_unix2.so nullok use_authtok',
            ]

            $default_pam_session_lines = [
              'session  required  pam_limits.so',
              'session  required  pam_unix2.so',
            ]
          }
        }
        '11': {
          $default_pam_d_login_template = 'pam/login.suse11.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.suse11.erb'
          $default_package_name         = 'pam'

          if $ensure_vas == 'present' {
            $default_pam_auth_lines = [
              'auth  required    pam_env.so',
              'auth  sufficient  pam_vas3.so create_homedir get_nonvas_pass',
              'auth  requisite   pam_vas3.so echo_return',
              'auth  required    pam_unix2.so use_first_pass',
            ]

            $default_pam_account_lines = [
              'account  sufficient  pam_vas3.so',
              'account  requisite   pam_vas3.so echo_return',
              'account  required    pam_unix2.so',
            ]

            $default_pam_password_lines = [
              'password  sufficient  pam_vas3.so',
              'password  requisite   pam_vas3.so echo_return',
              'password  requisite   pam_pwcheck.so nullok cracklib',
              'password  required    pam_unix2.so use_authtok nullok',
            ]

            $default_pam_session_lines = [
              'session  required   pam_limits.so',
              'session  required   pam_vas3.so create_homedir',
              'session  requisite  pam_vas3.so echo_return',
              'session  required   pam_unix2.so',
              'session  optional   pam_umask.so',
            ]
            } else {
              $default_pam_auth_lines = [
                'auth  required  pam_env.so',
                'auth  required  pam_unix2.so',
              ]

              $default_pam_account_lines = [
                'account  required  pam_unix2.so',
              ]

              $default_pam_password_lines = [
                'password  required  pam_pwcheck.so nullok cracklib',
                'password  required  pam_unix2.so nullok use_authtok',
              ]

              $default_pam_session_lines = [  'session  required  pam_limits.so',
                'session  required  pam_unix2.so',
                'session  optional  pam_umask.so',
              ]
            }
        }
        '12': {
          $default_pam_d_login_template = 'pam/login.suse12.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.suse12.erb'
          $default_package_name         = 'pam'

          if $ensure_vas == 'present' {
            $default_pam_auth_lines = [
              'auth  required    pam_env.so',
              'auth  sufficient  pam_vas3.so create_homedir get_nonvas_pass',
              'auth  requisite   pam_vas3.so echo_return',
              'auth  required    pam_unix2.so use_first_pass',
            ]

            $default_pam_account_lines = [
              'account  sufficient  pam_vas3.so',
              'account  requisite   pam_vas3.so echo_return',
              'account  required    pam_unix2.so',
            ]

            $default_pam_password_lines = [
              'password  sufficient  pam_vas3.so',
              'password  requisite   pam_vas3.so echo_return',
              'password  requisite   pam_pwcheck.so nullok cracklib',
              'password  required    pam_unix2.so use_authtok nullok',
            ]

            $default_pam_session_lines = [
              'session  required   pam_limits.so',
              'session  required   pam_vas3.so create_homedir',
              'session  requisite  pam_vas3.so echo_return',
              'session  required   pam_unix2.so',
              'session  optional   pam_umask.so',
              'session  optional   pam_systemd.so',
              'session  optional   pam_env.so',
            ]
          } else {
            $default_pam_auth_lines = [
              'auth  required  pam_env.so',
              'auth  required  pam_unix2.so',
            ]

            $default_pam_account_lines = [
              'account  required  pam_unix2.so',
            ]

            $default_pam_password_lines = [
              'password  required  pam_pwcheck.so nullok cracklib',
              'password  required  pam_unix2.so nullok use_authtok',
            ]

            $default_pam_session_lines = [
              'session  required  pam_limits.so',
              'session  required  pam_unix2.so',
              'session  optional  pam_umask.so',
              'session  optional  pam_systemd.so',
              'session  optional  pam_env.so',
            ]
          }
        }
        '13': {
          $default_pam_d_login_template = 'pam/login.suse13.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.suse13.erb'
          $default_package_name         = 'pam'

          if $ensure_vas == 'present' {
            fail("Pam: vas is not supported on ${::osfamily} ${::lsbmajdistrelease}")
          } else {
            $default_pam_auth_lines = [
              'auth  required  pam_env.so',
              'auth  optional  pam_gnome_keyring.so',
              'auth  required  pam_unix.so try_first_pass',
            ]

            $default_pam_account_lines = [
              'account  required  pam_unix.so try_first_pass',
            ]

            $default_pam_password_lines = [
              'password  requisite  pam_cracklib.so',
              'password  optional   pam_gnome_keyring.so use_authtok',
              'password  required   pam_unix.so use_authtok nullok shadow try_first_pass',
            ]

            $default_pam_session_lines = [
              'session  required pam_limits.so',
              'session  required pam_unix.so try_first_pass',
              'session  optional pam_umask.so',
              'session  optional pam_systemd.so',
              'session  optional pam_gnome_keyring.so auto_start only_if=gdm,gdm-password,lxdm,lightdm',
              'session  optional pam_env.so',
            ]
          }
        }
        default: {
          fail("Pam is only supported on Suse 9, 10, 11, 12 and 13. Your lsbmajdistrelease is identified as <${::lsbmajdistrelease}>.")
        }
      }
    }
    'Debian': {
      case $::lsbdistid {
        'Ubuntu': {
          case $::lsbdistrelease {
            '12.04': {
              $default_pam_d_login_template = 'pam/login.ubuntu12.erb'
              $default_pam_d_sshd_template  = 'pam/sshd.ubuntu12.erb'
              $default_package_name         = 'libpam0g'

              if $ensure_vas == 'present' {
                $default_pam_auth_lines = [
                  'auth        required    pam_env.so',
                  'auth        sufficient  pam_vas3.so show_lockout_msg get_nonvas_pass store_creds',
                  'auth        requisite   pam_vas3.so echo_return',
                  'auth        required    pam_unix.so use_first_pass',
                ]


                $default_pam_account_lines = [
                  'account sufficient  pam_vas3.so',
                  'account requisite   pam_vas3.so echo_return',
                  'account [success=1 new_authtok_reqd=done default=ignore]  pam_unix.so',
                  'account requisite   pam_deny.so',
                  'account required    pam_permit.so',
                ]

                $default_pam_password_lines = [
                  'password sufficient  pam_vas3.so',
                  'password  requisite pam_vas3.so echo_return',
                  'password  [success=1 default=ignore]  pam_unix.so obscure sha512',
                  'password  requisite pam_deny.so',
                  'password  required  pam_permit.so',
                ]

                $default_pam_session_lines = [
                  'session  [default=1] pam_permit.so',
                  'session requisite pam_deny.so',
                  'session required  pam_permit.so',
                  'session optional  pam_umask.so',
                  'session required  pam_vas3.so create_homedir',
                  'session requisite pam_vas3.so echo_return',
                  'session required  pam_unix.so',
                ]
              } else {

                $default_pam_auth_lines = [
                  'auth  [success=1 default=ignore]  pam_unix.so nullok_secure',
                  'auth  requisite     pam_deny.so',
                  'auth  required      pam_permit.so',
                ]

                $default_pam_account_lines = [
                  'account [success=1 new_authtok_reqd=done default=ignore]  pam_unix.so',
                  'account requisite     pam_deny.so',
                  'account required      pam_permit.so',
                ]

                $default_pam_password_lines = [
                  'password  [success=1 default=ignore]  pam_unix.so obscure sha512',
                  'password  requisite     pam_deny.so',
                  'password  required      pam_permit.so',
                ]

                $default_pam_session_lines = [
                  'session [default=1]   pam_permit.so',
                  'session requisite     pam_deny.so',
                  'session required      pam_permit.so',
                  'session optional      pam_umask.so',
                  'session required      pam_unix.so',
                ]
              }
            }
            '14.04': {
              $default_pam_d_login_template = 'pam/login.ubuntu14.erb'
              $default_pam_d_sshd_template  = 'pam/sshd.ubuntu14.erb'
              $default_package_name         = 'libpam0g'

              if $ensure_vas == 'present' {
                $default_pam_auth_lines = [
                  'auth        required    pam_env.so',
                  'auth        sufficient  pam_vas3.so show_lockout_msg get_nonvas_pass store_creds',
                  'auth        requisite   pam_vas3.so echo_return',
                  'auth        required    pam_unix.so use_first_pass',
                ]

                $default_pam_account_lines = [
                  'account sufficient  pam_vas3.so',
                  'account requisite   pam_vas3.so echo_return',
                  'account [success=1 new_authtok_reqd=done default=ignore]  pam_unix.so',
                  'account requisite   pam_deny.so',
                  'account required    pam_permit.so',
                ]

                $default_pam_password_lines = [
                  'password sufficient  pam_vas3.so',
                  'password  requisite pam_vas3.so echo_return',
                  'password  [success=1 default=ignore]  pam_unix.so obscure sha512',
                  'password  requisite pam_deny.so',
                  'password  required  pam_permit.so',
                ]

                $default_pam_session_lines = [
                  'session  [default=1] pam_permit.so',
                  'session requisite pam_deny.so',
                  'session required  pam_permit.so',
                  'session optional  pam_umask.so',
                  'session required  pam_vas3.so create_homedir',
                  'session requisite pam_vas3.so echo_return',
                  'session required  pam_unix.so',
                ]

              } else {

                $default_pam_auth_lines = [
                  'auth  [success=1 default=ignore]  pam_unix.so nullok_secure',
                  'auth  requisite     pam_deny.so',
                  'auth  required      pam_permit.so',
                  'auth  optional      pam_cap.so',
                ]

                $default_pam_account_lines = [
                  'account [success=1 new_authtok_reqd=done default=ignore]  pam_unix.so',
                  'account requisite     pam_deny.so',
                  'account required      pam_permit.so',
                ]

                $default_pam_password_lines = [
                  'password  [success=1 default=ignore]  pam_unix.so obscure sha512',
                  'password  requisite     pam_deny.so',
                  'password  required      pam_permit.so',
                ]

                $default_pam_session_lines = [
                  'session [default=1]   pam_permit.so',
                  'session requisite     pam_deny.so',
                  'session required      pam_permit.so',
                  'session optional      pam_umask.so',
                  'session required      pam_unix.so',
                  'session optional      pam_systemd.so',
                ]
              }
            }
            '16.04': {
              $default_pam_d_login_template = 'pam/login.ubuntu16.erb'
              $default_pam_d_sshd_template  = 'pam/sshd.ubuntu16.erb'
              $default_package_name         = 'libpam0g'

              if $ensure_vas == 'present' {
                fail("/Pam: vas is not supported on Ubuntu ${::lsbdistrelease}/")
              } else {

                $default_pam_auth_lines = [
                  'auth  [success=1 default=ignore]  pam_unix.so nullok_secure',
                  'auth  requisite     pam_deny.so',
                  'auth  required      pam_permit.so',
                ]

                $default_pam_account_lines = [
                  'account [success=1 new_authtok_reqd=done default=ignore]  pam_unix.so',
                  'account requisite     pam_deny.so',
                  'account required      pam_permit.so',
                ]

                $default_pam_password_lines = [
                  'password  [success=1 default=ignore]  pam_unix.so obscure sha512',
                  'password  requisite     pam_deny.so',
                  'password  required      pam_permit.so',
                ]

                $default_pam_session_lines = [
                  'session [default=1]   pam_permit.so',
                  'session requisite     pam_deny.so',
                  'session required      pam_permit.so',
                  'session optional      pam_umask.so',
                  'session required      pam_unix.so',
                  'session optional      pam_systemd.so',
                ]
              }
            }
            default: {
              fail("Pam is only supported on Ubuntu 12.04, 14.04 and 16.04. Your lsbdistrelease is identified as <${::lsbdistrelease}>.")
            }
          }
        }
        'Debian': {
          case $::lsbmajdistrelease {
            '8': {

              if $ensure_vas == 'present' {
                fail("Pam: vas is not supported on ${::osfamily} ${::lsbmajdistrelease}")
              }
              $default_pam_d_login_template = 'pam/login.debian8.erb'
              $default_pam_d_sshd_template  = 'pam/sshd.debian8.erb'
              $default_package_name         = 'libpam0g'


              $default_pam_auth_lines = [
                'auth  [success=1 default=ignore]  pam_unix.so nullok_secure',
                'auth  requisite     pam_deny.so',
                'auth  required      pam_permit.so',
              ]

              $default_pam_account_lines = [
                'account [success=1 new_authtok_reqd=done default=ignore]  pam_unix.so',
                'account requisite     pam_deny.so',
                'account required      pam_permit.so',
              ]

              $default_pam_password_lines = [
                'password  [success=1 default=ignore]  pam_unix.so obscure sha512',
                'password  requisite     pam_deny.so',
                'password  required      pam_permit.so',
              ]

              $default_pam_session_lines = [
                'session [default=1]   pam_permit.so',
                'session requisite     pam_deny.so',
                'session required      pam_permit.so',
                'session required      pam_unix.so',
              ]


            }
            default: {
              fail("Pam is only supported on Debian 8. Your lsbmajdistrelease is <${::lsbmajdistrelease}>.")
            }
          }
        }
        default: {
          fail("Pam is only supported on lsbdistid Ubuntu or Debian of the Debian osfamily. Your lsbdistid is <${::lsbdistid}>.")
        }
      }
    }
    'Solaris': {
      $default_package_name         = undef
      $default_pam_d_login_template = undef
      $default_pam_d_sshd_template  = undef
      case $::kernelrelease {
        '5.9': {
          $default_pam_auth_lines = [
            'login   auth requisite          pam_authtok_get.so.1',
            'login   auth required           pam_dhkeys.so.1',
            'login   auth required           pam_unix_auth.so.1',
            'login   auth required           pam_dial_auth.so.1',
            'passwd  auth required           pam_passwd_auth.so.1',
            'other   auth requisite          pam_authtok_get.so.1',
            'other   auth required           pam_dhkeys.so.1',
            'other   auth required           pam_unix_auth.so.1',
          ]

          $default_pam_account_lines = [
            'cron    account required        pam_projects.so.1',
            'cron    account required        pam_unix_account.so.1',
            'other   account requisite       pam_roles.so.1',
            'other   account required        pam_projects.so.1',
            'other   account required        pam_unix_account.so.1',
          ]

          $default_pam_password_lines = [
            'other   password required       pam_dhkeys.so.1',
            'other   password requisite      pam_authtok_get.so.1',
            'other   password requisite      pam_authtok_check.so.1',
            'other   password required       pam_authtok_store.so.1',
          ]

          $default_pam_session_lines = [
            'other   session required        pam_unix_session.so.1',
          ]
        }
        '5.10': {
          if $ensure_vas == 'present' {
            $default_pam_auth_lines = [
              'login   auth     required        pam_unix_cred.so.1',
              'login   auth     sufficient      pam_vas3.so create_homedir get_nonvas_pass try_first_pass',
              'login   auth     requisite       pam_vas3.so echo_return',
              'login   auth     requisite       pam_authtok_get.so.1 use_first_pass',
              'login   auth     required        pam_dhkeys.so.1',
              'login   auth     required        pam_unix_auth.so.1',
              'login   auth     required        pam_dial_auth.so.1',
              'rlogin  auth     required        pam_unix_cred.so.1',
              'rlogin  auth     sufficient      pam_vas3.so create_homedir get_nonvas_pass try_first_pass',
              'rlogin  auth     requisite       pam_vas3.so echo_return',
              'rlogin  auth     requisite       pam_authtok_get.so.1 use_first_pass',
              'rlogin  auth     required        pam_dhkeys.so.1',
              'rlogin  auth     required        pam_unix_auth.so.1',
              'krlogin auth     required        pam_unix_cred.so.1',
              'krlogin auth     sufficient      pam_vas3.so create_homedir get_nonvas_pass try_first_pass',
              'krlogin auth     requisite       pam_vas3.so echo_return',
              'krlogin auth     required        pam_krb5.so.1 use_first_pass',
              'krsh    auth     required        pam_unix_cred.so.1',
              'krsh    auth     sufficient      pam_vas3.so create_homedir get_nonvas_pass try_first_pass',
              'krsh    auth     requisite       pam_vas3.so echo_return',
              'krsh    auth     required        pam_krb5.so.1 use_first_pass',
              'ktelnet auth     required        pam_unix_cred.so.1',
              'ktelnet auth     sufficient      pam_vas3.so create_homedir get_nonvas_pass try_first_pass',
              'ktelnet auth     requisite       pam_vas3.so echo_return',
              'ktelnet auth     required        pam_krb5.so.1 use_first_pass',
              'ppp     auth     required        pam_unix_cred.so.1',
              'ppp     auth     sufficient      pam_vas3.so create_homedir get_nonvas_pass try_first_pass',
              'ppp     auth     requisite       pam_vas3.so echo_return',
              'ppp     auth     requisite       pam_authtok_get.so.1 use_first_pass',
              'ppp     auth     required        pam_dhkeys.so.1',
              'ppp     auth     required        pam_unix_auth.so.1',
              'ppp     auth     required        pam_dial_auth.so.1',
              'other   auth     required        pam_unix_cred.so.1',
              'other   auth     sufficient      pam_vas3.so create_homedir get_nonvas_pass try_first_pass',
              'other   auth     requisite       pam_vas3.so echo_return',
              'other   auth     requisite       pam_authtok_get.so.1 use_first_pass',
              'other   auth     required        pam_dhkeys.so.1',
              'other   auth     required        pam_unix_auth.so.1',
              'passwd  auth     sufficient      pam_vas3.so create_homedir get_nonvas_pass try_first_pass',
              'passwd  auth     requisite       pam_vas3.so echo_return',
              'passwd  auth     required        pam_passwd_auth.so.1 use_first_pass',
            ]

            $default_pam_account_lines  = [ 'cron    account  sufficient      pam_vas3.so',
              'cron    account  requisite       pam_vas3.so echo_return',
              'cron    account  required        pam_unix_account.so.1',
              'other   account  requisite       pam_roles.so.1',
              'other   account  sufficient      pam_vas3.so',
              'other   account  requisite       pam_vas3.so echo_return',
              'other   account  required        pam_unix_account.so.1',
            ]

            $default_pam_password_lines = [
              'other   password required        pam_dhkeys.so.1',
              'other   password requisite       pam_authtok_get.so.1',
              'other   password sufficient      pam_vas3.so',
              'other   password requisite       pam_vas3.so echo_return',
              'other   password requisite       pam_authtok_check.so.1',
              'other   password required        pam_authtok_store.so.1',
            ]

            $default_pam_session_lines  = [
              'other   session  required        pam_vas3.so create_homedir',
              'other   session  requisite       pam_vas3.so echo_return',
              'other   session  required        pam_unix_session.so.1',
            ]
          } else {
            $default_pam_auth_lines = [
              'login   auth requisite          pam_authtok_get.so.1',
              'login   auth required           pam_dhkeys.so.1',
              'login   auth required           pam_unix_cred.so.1',
              'login   auth required           pam_unix_auth.so.1',
              'login   auth required           pam_dial_auth.so.1',
              'passwd  auth required           pam_passwd_auth.so.1',
              'other   auth requisite          pam_authtok_get.so.1',
              'other   auth required           pam_dhkeys.so.1',
              'other   auth required           pam_unix_cred.so.1',
              'other   auth required           pam_unix_auth.so.1',
            ]

            $default_pam_account_lines = [
              'other   account requisite       pam_roles.so.1',
              'other   account required        pam_unix_account.so.1',
            ]

            $default_pam_password_lines = [
              'other   password required       pam_dhkeys.so.1',
              'other   password requisite      pam_authtok_get.so.1',
              'other   password requisite      pam_authtok_check.so.1',
              'other   password required       pam_authtok_store.so.1',
            ]

            $default_pam_session_lines = [
              'other   session required        pam_unix_session.so.1',
            ]
          }
        }

        '5.11': {
          $default_pam_auth_lines = [
            'auth definitive         pam_user_policy.so.1',
            'auth requisite          pam_authtok_get.so.1',
            'auth required           pam_dhkeys.so.1',
            'auth required           pam_unix_auth.so.1',
            'auth required           pam_unix_cred.so.1',
          ]

          $default_pam_account_lines = [
            'account requisite       pam_roles.so.1',
            'account definitive      pam_user_policy.so.1',
            'account required        pam_unix_account.so.1',
            'account required        pam_tsol_account.so.1',
          ]

          $default_pam_password_lines = [
            'password definitive     pam_user_policy.so.1',
            'password include        pam_authtok_common',
            'password required       pam_authtok_store.so.1',
          ]

          $default_pam_session_lines = [
            'session definitive      pam_user_policy.so.1',
            'session required        pam_unix_session.so.1',
          ]
        }

        default: {
          fail("Pam is only supported on Solaris 9, 10 and 11. Your kernelrelease is identified as <${::kernelrelease}>.")
        }
      }
    }
    default: {
      fail("Pam is only supported on RedHat, Suse, Debian and Solaris osfamilies. Your osfamily is identified as <${::osfamily}>.")
    }
  }

  $valid_pam_access_values = ['^required$', '^requisite$', '^sufficient$', '^optional$', '^absent$']

  validate_re($login_pam_access, $valid_pam_access_values,
    "pam::login_pam_access is <${login_pam_access}> and must be either 'required', 'requisite', 'sufficient', 'optional' or 'absent'.")

  validate_re($sshd_pam_access, $valid_pam_access_values,
    "pam::sshd_pam_access is <${sshd_pam_access}> and must be either 'required', 'requisite', 'sufficient', 'optional' or 'absent'.")

  if is_string($limits_fragments_hiera_merge) == true {
    $limits_fragments_hiera_merge_real = str2bool($limits_fragments_hiera_merge)
  } else {
    $limits_fragments_hiera_merge_real = $limits_fragments_hiera_merge
  }
  validate_bool($limits_fragments_hiera_merge_real)

  if $package_name == undef {
    $my_package_name = $default_package_name
  } else {
    $my_package_name = $package_name
  }

  if $pam_d_login_template == undef {
    $my_pam_d_login_template = $default_pam_d_login_template
  } else {
    $my_pam_d_login_template = $pam_d_login_template
  }

  if $pam_d_sshd_template == 'pam/sshd.custom.erb' {
    if $pam_sshd_auth_lines == undef or
      $pam_sshd_account_lines == undef or
      $pam_sshd_password_lines == undef or
      $pam_sshd_session_lines == undef {
        fail('pam_sshd_[auth|account|password|session]_lines required when using the pam/sshd.custom.erb template')
    }
    validate_array($pam_sshd_auth_lines)
    validate_array($pam_sshd_account_lines)
    validate_array($pam_sshd_password_lines)
    validate_array($pam_sshd_session_lines)
  } else {
    if $pam_sshd_auth_lines != undef or
      $pam_sshd_account_lines != undef or
      $pam_sshd_password_lines != undef or
      $pam_sshd_session_lines != undef {
        fail('pam_sshd_[auth|account|password|session]_lines are only valid when pam_d_sshd_template is configured with the pam/sshd.custom.erb template')
    }
  }

  if $pam_d_sshd_template == undef {
    $my_pam_d_sshd_template = $default_pam_d_sshd_template
  } else {
    $my_pam_d_sshd_template = $pam_d_sshd_template
  }

  if $pam_auth_lines == undef {
    if $system_auth_ac_auth_lines == undef {
      $my_pam_auth_lines = $default_pam_auth_lines
    } else {
      $my_pam_auth_lines = $system_auth_ac_auth_lines
      notify { 'Deprecation notice: `$system_auth_ac_auth_lines` has been deprecated in `pam` class and will be removed in a future version. Use $pam_auth_lines instead.': }
    }
  } else {
    $my_pam_auth_lines = $pam_auth_lines
  }

  if $pam_account_lines == undef {
    if $system_auth_ac_account_lines == undef {
      $my_pam_account_lines = $default_pam_account_lines
    } else {
      $my_pam_account_lines = $system_auth_ac_account_lines
      notify { 'Deprecation notice: `$system_auth_ac_account_lines` has been deprecated in `pam` class and will be removed in a future version. Use $pam_account_lines instead.': }
    }
  } else {
    $my_pam_account_lines = $pam_account_lines
  }

  if $pam_password_lines == undef {
    if $system_auth_ac_password_lines == undef {
      $my_pam_password_lines = $default_pam_password_lines
    } else {
      $my_pam_password_lines = $system_auth_ac_password_lines
      notify { 'Deprecation notice: `$system_auth_ac_password_lines` has been deprecated in `pam` class and will be removed in a future version. Use $pam_password_lines instead.': }
    }
  } else {
    $my_pam_password_lines = $pam_password_lines
  }

  if $pam_session_lines == undef {
    if $system_auth_ac_session_lines == undef {
      $my_pam_session_lines = $default_pam_session_lines
    } else {
      $my_pam_session_lines = $system_auth_ac_session_lines
      notify { 'Deprecation notice: `$system_auth_ac_session_lines` has been deprecated in `pam` class and will be removed in a future version. Use $pam_session_lines instead.': }
    }
  } else {
    $my_pam_session_lines = $pam_session_lines
  }

if ( $::osfamily == 'RedHat' ) and ( $::operatingsystemmajrelease == '6' or $::operatingsystemmajrelease == '7' ) {
  if $pam_password_auth_lines == undef {
    $my_pam_password_auth_lines = $default_pam_password_auth_lines
  } else {
    $my_pam_password_auth_lines = $pam_password_auth_lines
  }
  validate_array($my_pam_password_auth_lines)

  if $pam_password_account_lines == undef {
    $my_pam_password_account_lines = $default_pam_password_account_lines
  } else {
    $my_pam_password_account_lines = $pam_password_account_lines
  }
  validate_array($my_pam_password_account_lines)

  if $pam_password_password_lines == undef {
    $my_pam_password_password_lines = $default_pam_password_password_lines
  } else {
    $my_pam_password_password_lines = $pam_password_password_lines
  }
  validate_array($my_pam_password_password_lines)

  if $pam_password_session_lines == undef {
    $my_pam_password_session_lines = $default_pam_password_session_lines
  } else {
    $my_pam_password_session_lines = $pam_password_session_lines
  }
  validate_array($my_pam_password_session_lines)
}

  if $services != undef {
    create_resources('pam::service',$services)
  }

  if $limits_fragments != undef {
    if $limits_fragments_hiera_merge_real == true {
      $limits_fragments_real = hiera_hash('pam::limits_fragments')
    } else {
      $limits_fragments_real = $limits_fragments
    }
    create_resources('pam::limits::fragment',$limits_fragments_real)
  }

  validate_absolute_path($password_auth_ac_file)
  validate_absolute_path($password_auth_file)

  case $::osfamily {
    'RedHat', 'Suse', 'Debian': {

      include ::pam::accesslogin
      include ::pam::limits

      package { $my_package_name:
        ensure => installed,
      }

      file { 'pam_d_login':
        ensure  => file,
        path    => $pam_d_login_path,
        content => template($my_pam_d_login_template),
        owner   => $pam_d_login_owner,
        group   => $pam_d_login_group,
        mode    => $pam_d_login_mode,
      }

      file { 'pam_d_sshd':
        ensure  => file,
        path    => $pam_d_sshd_path,
        content => template($my_pam_d_sshd_template),
        owner   => $pam_d_sshd_owner,
        group   => $pam_d_sshd_group,
        mode    => $pam_d_sshd_mode,
      }

      case $::osfamily {
        'RedHat': {
          file { 'pam_system_auth_ac':
            ensure  => file,
            path    => $system_auth_ac_file,
            content => template('pam/system-auth-ac.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            require => Package[$my_package_name],
          }

          file { 'pam_system_auth':
            ensure  => symlink,
            path    => $system_auth_file,
            target  => $system_auth_ac_file,
            owner   => 'root',
            group   => 'root',
            require => Package[$my_package_name],
          }

          if $::operatingsystemmajrelease == '6' or $::operatingsystemmajrelease == '7' {
            file { 'pam_password_auth_ac':
              ensure  => file,
              path    => $password_auth_ac_file,
              content => template('pam/password-auth-ac.erb'),
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              require => Package[$my_package_name],
            }

            file { 'pam_password_auth':
              ensure  => symlink,
              path    => $password_auth_file,
              target  => $password_auth_ac_file,
              owner   => 'root',
              group   => 'root',
              require => Package[$my_package_name],
            }
          }
        }
        'Debian' : {

          file { 'pam_common_auth':
            ensure  => file,
            path    => $common_auth_file,
            content => template('pam/common-auth-pc.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            require => Package[$my_package_name],
          }

          file { 'pam_common_account':
            ensure  => file,
            path    => $common_account_file,
            content => template('pam/common-account-pc.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            require => Package[$my_package_name],
          }

          file { 'pam_common_password':
            ensure  => file,
            path    => $common_password_file,
            content => template('pam/common-password-pc.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            require => Package[$my_package_name],
          }

          file { 'pam_common_noninteractive_session':
            ensure  => file,
            path    => $common_session_noninteractive_file,
            content => template('pam/common-session-pc.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            require => Package[$my_package_name],
          }

          file { 'pam_common_session':
            ensure  => file,
            path    => $common_session_file,
            content => template('pam/common-session-pc.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            require => Package[$my_package_name],
          }
        }
        'Suse': {
          case $::lsbmajdistrelease {
            '9': {

              file { 'pam_other':
                ensure  => file,
                path    => $pam_d_other_file,
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                content => template('pam/pam.conf.erb'),
              }
            }
            '10': {

              file { 'pam_common_auth':
                ensure  => file,
                path    => $common_auth_file,
                content => template('pam/common-auth-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_account':
                ensure  => file,
                path    => $common_account_file,
                content => template('pam/common-account-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_password':
                ensure  => file,
                path    => $common_password_file,
                content => template('pam/common-password-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_session':
                ensure  => file,
                path    => $common_session_file,
                content => template('pam/common-session-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }
            }
            '11': {

              file { 'pam_common_auth_pc':
                ensure  => file,
                path    => $common_auth_pc_file,
                content => template('pam/common-auth-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_account_pc':
                ensure  => file,
                path    => $common_account_pc_file,
                content => template('pam/common-account-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_password_pc':
                ensure  => file,
                path    =>  $common_password_pc_file,
                content => template('pam/common-password-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_session_pc':
                ensure  => file,
                path    => $common_session_pc_file,
                content => template('pam/common-session-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_session':
                ensure  => symlink,
                path    => $common_session_file,
                target  => $common_session_pc_file,
                owner   => 'root',
                group   => 'root',
                require => Package[$my_package_name],
              }

              file { 'pam_common_password':
                ensure  => symlink,
                path    => $common_password_file,
                target  => $common_password_pc_file,
                owner   => 'root',
                group   => 'root',
                require => Package[$my_package_name],
              }

              file { 'pam_common_account':
                ensure  => symlink,
                path    => $common_account_file,
                target  => $common_account_pc_file,
                owner   => 'root',
                group   => 'root',
                require => Package[$my_package_name],
              }

              file { 'pam_common_auth':
                ensure  => symlink,
                path    => $common_auth_file,
                target  => $common_auth_pc_file,
                owner   => 'root',
                group   => 'root',
                require => Package[$my_package_name],
              }
            }
            '12','13': {

              file { 'pam_common_auth_pc':
                ensure  => file,
                path    => $common_auth_pc_file,
                content => template('pam/common-auth-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_account_pc':
                ensure  => file,
                path    => $common_account_pc_file,
                content => template('pam/common-account-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_password_pc':
                ensure  => file,
                path    =>  $common_password_pc_file,
                content => template('pam/common-password-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_session_pc':
                ensure  => file,
                path    => $common_session_pc_file,
                content => template('pam/common-session-pc.erb'),
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => Package[$my_package_name],
              }

              file { 'pam_common_session':
                ensure  => symlink,
                path    => $common_session_file,
                target  => $common_session_pc_file,
                owner   => 'root',
                group   => 'root',
                require => Package[$my_package_name],
              }

              file { 'pam_common_password':
                ensure  => symlink,
                path    => $common_password_file,
                target  => $common_password_pc_file,
                owner   => 'root',
                group   => 'root',
                require => Package[$my_package_name],
              }

              file { 'pam_common_account':
                ensure  => symlink,
                path    => $common_account_file,
                target  => $common_account_pc_file,
                owner   => 'root',
                group   => 'root',
                require => Package[$my_package_name],
              }

              file { 'pam_common_auth':
                ensure  => symlink,
                path    => $common_auth_file,
                target  => $common_auth_pc_file,
                owner   => 'root',
                group   => 'root',
                require => Package[$my_package_name],
              }
            }
            default : {
              fail("Pam is only supported on Suse 9, 10, 11, 12 and 13. Your lsbmajdistrelease is identified as <${::lsbmajdistrelease}>.")
            }
          }
        }
        default: {
          fail('Pam is not supported on your osfamily')
        }
      }
    }

    'Solaris': {
      case $::kernelrelease {
        '5.9','5.10': {
          file { 'pam_conf':
            ensure  => file,
            path    => $pam_conf_file,
            owner   => 'root',
            group   => 'sys',
            mode    => '0644',
            content => template('pam/pam.conf.erb'),
          }
        }
        '5.11': {
          file { 'pam_other':
            ensure  => file,
            path    => $pam_d_other_file,
            owner   => 'root',
            group   => 'sys',
            mode    => '0644',
            content => template('pam/pam.conf.erb'),
          }
        }
        default: {
          fail("Pam is only supported on Solaris 9, 10 and 11. Your kernelrelease is identified as <${::kernelrelease}>.")
        }
      }
    }
    default: {
      fail("Pam is only supported on RedHat, SuSE, Debian and Solaris osfamilies. Your osfamily is identified as <${::osfamily}>.")
    }
  }
}
