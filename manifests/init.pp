# # Class: pam #
# 
# This module manages bits around PAM.
# 
# # Parameters #
# 
# allowed_users
# -------------
# Array of users allowed to log in.
# 
# - *Default*: root
# 
# package_name
# ------------
# Array of packages providing the pam functionality. If undef, parameter is set based on the OS version.
# 
# - *Default*: undef, default is set based on OS version
# 
# pam_d_login_oracle_options
# --------------------------
# Allow array of extra lines at the bottom of pam.d/login for oracle systems on EL5.
# 
# - *Default*: UNSET
# 
# pam_d_login_path
# ----------------
# PAM login path
# 
# - *Default*: '/etc/pam.d/login'
# 
# pam_d_login_owner
# -----------------
# Owner of $pam_d_login_path
# 
# - *Default*: 'root'
# 
# pam_d_login_group
# -----------------
# Group of $pam_d_login_path
# 
# - *Default*: 'root'
# 
# pam_d_login_mode
# ----------------
# Mode of $pam_d_login_path
# 
# - *Default*: '0644'
# 
# pam_d_login_template
# --------------------
# Content template of $pam_d_login_path. If undef, parameter is set based on the OS version.
# 
# - *Default*: undef, default is set based on OS version
# 
# pam_d_sshd_path
# ---------------
# PAM sshd path
# 
# - *Default*: '/etc/pam.d/sshd'
# 
# pam_d_sshd_owner
# ----------------
# Owner of $pam_d_sshd_path
# 
# - *Default*: 'root'
# 
# pam_d_sshd_group
# ----------------
# Group of $pam_d_sshd_path
# 
# - *Default*: 'root'
# 
# pam_d_sshd_mode
# ---------------
# Mode of $pam_d_sshd_path
# 
# - *Default*: '0644'
# 
# pam_d_sshd_template
# -------------------
# Content template of $pam_d_sshd_path. If undef, parameter is set based on the OS version.
# 
# - *Default*: undef, default is set based on OS version
# 
# system_auth_file
# ----------------
# Path to system-auth.
# 
# - *Default*: '/etc/pam.d/system-auth'
# 
# system_auth_ac_file
# -------------------
# Path to system-auth-ac
# 
# - *Default*: '/etc/pam.d/system-auth-ac'
# 
# system_auth_ac_auth_lines
# -------------------------
# Content template of $system_auth_ac_file. If undef, parameter is set based on the OS version.
# 
# - *Default*: undef, default is set based on OS version
# 
# system_auth_ac_account_lines
# ----------------------------
# Content template of $system_auth_ac_file. If undef, parameter is set based on the OS version.
# 
# - *Default*: undef, default is set based on OS version
# 
# system_auth_ac_password_lines
# -----------------------------
# Content template of $system_auth_ac_file. If undef, parameter is set based on the OS version.
# 
# - *Default*: undef, default is set based on OS version
# 
# system_auth_ac_session_lines
# ----------------------------
# Content template of $system_auth_ac_file. If undef, parameter is set based on the OS version.
# 
# - *Default*: undef, default is set based on OS version
# 
class pam (
  $allowed_users                 = 'root',
  $package_name                  = undef,
  $pam_d_login_oracle_options    = 'UNSET',
  $pam_d_login_path              = '/etc/pam.d/login',
  $pam_d_login_owner             = 'root',
  $pam_d_login_group             = 'root',
  $pam_d_login_mode              = '0644',
  $pam_d_login_template          = undef,
  $pam_d_sshd_path               = '/etc/pam.d/sshd',
  $pam_d_sshd_owner              = 'root',
  $pam_d_sshd_group              = 'root',
  $pam_d_sshd_mode               = '0644',
  $pam_d_sshd_template           = undef,
  $system_auth_file              = '/etc/pam.d/system-auth',
  $system_auth_ac_file           = '/etc/pam.d/system-auth-ac',
  $system_auth_ac_auth_lines     = undef,
  $system_auth_ac_account_lines  = undef,
  $system_auth_ac_password_lines = undef,
  $system_auth_ac_session_lines  = undef,
) {

  include nsswitch
  include pam::accesslogin
  include pam::limits

  case $::osfamily {
    'redhat': {
      case $::lsbmajdistrelease {
        '5': {
          $default_pam_d_login_template = 'pam/login.el5.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.el5.erb'
          $default_package_name         = [ 'pam',
                                      'util-linux' ]

          $default_system_auth_ac_auth_lines = [ 'auth        required      pam_env.so',
                                          'auth        sufficient    pam_unix.so nullok try_first_pass',
                                          'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
                                          'auth        required      pam_deny.so']

          $default_system_auth_ac_account_lines = [ 'account     required      pam_unix.so',
                                            'account     sufficient    pam_succeed_if.so uid < 500 quiet',
                                            'account     required      pam_permit.so']

          $default_system_auth_ac_password_lines = [ 'password    requisite     pam_cracklib.so try_first_pass retry=3',
                                            'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
                                            'password    required      pam_deny.so']

          $default_system_auth_ac_session_lines = [ 'session     optional      pam_keyinit.so revoke',
                                            'session     required      pam_limits.so',
                                            'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
                                            'session     required      pam_unix.so']
        }
        '6': {
          $default_pam_d_login_template = 'pam/login.el6.erb'
          $default_pam_d_sshd_template  = 'pam/sshd.el6.erb'
          $default_package_name         = 'pam'

          $default_system_auth_ac_auth_lines = [ 'auth        required      pam_env.so',
                                        'auth        sufficient    pam_fprintd.so',
                                        'auth        sufficient    pam_unix.so nullok try_first_pass',
                                        'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
                                        'auth        required      pam_deny.so']

          $default_system_auth_ac_account_lines = [ 'account     required      pam_unix.so',
                                            'account     sufficient    pam_localuser.so',
                                            'account     sufficient    pam_succeed_if.so uid < 500 quiet',
                                            'account     required      pam_permit.so']

          $default_system_auth_ac_password_lines = [ 'password    requisite     pam_cracklib.so try_first_pass retry=3 type=',
                                            'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
                                            'password    required      pam_deny.so']

          $default_system_auth_ac_session_lines = [ 'session     optional      pam_keyinit.so revoke',
                                            'session     required      pam_limits.so',
                                            'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
                                            'session     required      pam_unix.so']
        }
        default: {
          fail("${module_name} is only supported on EL 5 and 6. Your lsbmajdistrelease is identified as ${::lsbmajdistrelease}")
        }
      }
    }
    default: {
      fail("${module_name} is only supported on RedHat systems. Your osfamily is identified as ${::osfamily}")
    }
  }

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

  if $pam_d_sshd_template == undef {
    $my_pam_d_sshd_template = $default_pam_d_sshd_template
  } else {
    $my_pam_d_sshd_template = $pam_d_sshd_template
  }

  if $system_auth_ac_auth_lines == undef {
    $my_system_auth_ac_auth_lines = $default_system_auth_ac_auth_lines
  } else {
    $my_system_auth_ac_auth_lines = $system_auth_ac_auth_lines
  }

  if $system_auth_ac_account_lines == undef {
    $my_system_auth_ac_account_lines = $default_system_auth_ac_account_lines
  } else {
    $my_system_auth_ac_account_lines = $system_auth_ac_account_lines
  }

  if $system_auth_ac_password_lines == undef {
    $my_system_auth_ac_password_lines = $default_system_auth_ac_password_lines
  } else {
    $my_system_auth_ac_password_lines = $system_auth_ac_password_lines
  }

  if $system_auth_ac_session_lines == undef {
    $my_system_auth_ac_session_lines = $default_system_auth_ac_session_lines
  } else {
    $my_system_auth_ac_session_lines = $system_auth_ac_session_lines
  }

  package { 'pam_package':
    ensure => installed,
    name   => $my_package_name,
  }

  file { 'pam_system_auth_ac':
    ensure  => file,
    path    => $system_auth_ac_file,
    content => template('pam/system-auth-ac.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['pam_package'],
  }

  file { 'pam_system_auth':
    ensure  => symlink,
    path    => $system_auth_file,
    target  => $system_auth_ac_file,
    owner   => 'root',
    group   => 'root',
    require => Package['pam_package'],
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
}
