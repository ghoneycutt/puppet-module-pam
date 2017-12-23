# == Class: pam
#
# This module manages bits around PAM.
#
class pam (
  Variant[String, Array, Hash] $allowed_users               = 'root',
  Enum['required', 'requisite', 'sufficient', 'optional', 'absent']
    $login_pam_access                                       = 'required',
  Enum['required', 'requisite', 'sufficient', 'optional', 'absent']
    $sshd_pam_access                                        = 'required',
  Optional[Variant[String, Array]] $package_name            = undef,
  Stdlib::Absolutepath $pam_conf_file                       = '/etc/pam.conf',
  Optional[Hash] $services                                  = undef,
  Optional[Hash] $limits_fragments                          = undef,
  Boolean $limits_fragments_hiera_merge                     = false,
  Variant[Array, Enum['UNSET']] $pam_d_login_oracle_options = 'UNSET',
  Stdlib::Absolutepath $pam_d_login_path                    = '/etc/pam.d/login',
  String $pam_d_login_owner                                 = 'root',
  String $pam_d_login_group                                 = 'root',
  Pattern[/^[0-7]{4}$/] $pam_d_login_mode                   = '0644',
  Optional[String] $pam_d_login_template                    = undef,
  Stdlib::Absolutepath $pam_d_sshd_path                     = '/etc/pam.d/sshd',
  String $pam_d_sshd_owner                                  = 'root',
  String $pam_d_sshd_group                                  = 'root',
  Pattern[/^[0-7]{4}$/] $pam_d_sshd_mode                    = '0644',
  Optional[String] $pam_d_sshd_template                     = undef,
  Optional[Array] $pam_sshd_auth_lines                      = undef,
  Optional[Array] $pam_sshd_account_lines                   = undef,
  Optional[Array] $pam_sshd_password_lines                  = undef,
  Optional[Array] $pam_sshd_session_lines                   = undef,
  Optional[Array] $pam_auth_lines                           = undef,
  Optional[Array] $pam_account_lines                        = undef,
  Optional[Array] $pam_password_lines                       = undef,
  Optional[Array] $pam_session_lines                        = undef,
  Stdlib::Absolutepath $other_file                          = '/etc/pam.d/other',
  Stdlib::Absolutepath $common_auth_file                    = '/etc/pam.d/common-auth',
  Stdlib::Absolutepath $common_auth_pc_file                 = '/etc/pam.d/common-auth-pc',
  Stdlib::Absolutepath $common_account_file                 = '/etc/pam.d/common-account',
  Stdlib::Absolutepath $common_account_pc_file              = '/etc/pam.d/common-account-pc',
  Stdlib::Absolutepath $common_password_file                = '/etc/pam.d/common-password',
  Stdlib::Absolutepath $common_password_pc_file             = '/etc/pam.d/common-password-pc',
  Stdlib::Absolutepath $common_session_file                 = '/etc/pam.d/common-session',
  Stdlib::Absolutepath $common_session_pc_file              = '/etc/pam.d/common-session-pc',
  Stdlib::Absolutepath $common_session_noninteractive_file  = '/etc/pam.d/common-session-noninteractive',
  Stdlib::Absolutepath $system_auth_file                    = '/etc/pam.d/system-auth',
  Stdlib::Absolutepath $system_auth_ac_file                 = '/etc/pam.d/system-auth-ac',
  Stdlib::Absolutepath $password_auth_file                  = '/etc/pam.d/password-auth',
  Stdlib::Absolutepath $password_auth_ac_file               = '/etc/pam.d/password-auth-ac',
  Optional[Array] $pam_password_auth_lines                  = undef,
  Optional[Array] $pam_password_account_lines               = undef,
  Optional[Array] $pam_password_password_lines              = undef,
  Optional[Array] $pam_password_session_lines               = undef,
  Boolean $manage_nsswitch                                  = true,
) {

  if $manage_nsswitch {
    include ::nsswitch
  }

  if $pam_d_sshd_template == 'pam/sshd.custom.erb' {
    unless $pam_sshd_auth_lines and
      $pam_sshd_account_lines and
      $pam_sshd_password_lines and
      $pam_sshd_session_lines {
        fail('pam_sshd_[auth|account|password|session]_lines required when using the pam/sshd.custom.erb template')
    }
  } else {
    if $pam_sshd_auth_lines or
      $pam_sshd_account_lines or
      $pam_sshd_password_lines or
      $pam_sshd_session_lines {
        fail('pam_sshd_[auth|account|password|session]_lines are only valid when pam_d_sshd_template is configured with the pam/sshd.custom.erb template')
    }
  }

  if $services {
    create_resources('pam::service',$services)
  }

  if $limits_fragments {
    if $limits_fragments_hiera_merge {
      $limits_fragments_real = hiera_hash('pam::limits_fragments')
    } else {
      $limits_fragments_real = $limits_fragments
    }
    create_resources('pam::limits::fragment',$limits_fragments_real)
  }

  case $facts['os']['family'] {
    'RedHat', 'Suse', 'Debian': {

      include ::pam::accesslogin
      include ::pam::limits

      package { $package_name:
        ensure => installed,
      }

      file { 'pam_d_login':
        ensure  => file,
        path    => $pam_d_login_path,
        content => template($pam_d_login_template),
        owner   => $pam_d_login_owner,
        group   => $pam_d_login_group,
        mode    => $pam_d_login_mode,
      }

      file { 'pam_d_sshd':
        ensure  => file,
        path    => $pam_d_sshd_path,
        content => template($pam_d_sshd_template),
        owner   => $pam_d_sshd_owner,
        group   => $pam_d_sshd_group,
        mode    => $pam_d_sshd_mode,
      }

      case $facts['os']['family'] {
        'RedHat': {
          case $facts['os']['release']['major'] {
            '5':  {
              $_common_files        = [ 'system_auth' ]
              $_common_files_suffix = '_ac'
              $_add_links           = true
            }
            '6','7': {
              $_common_files        = [ 'password_auth', 'system_auth' ]
              $_common_files_suffix = '_ac'
              $_add_links           = true
            }
            default : {
              fail("osfamily RedHat's os.release.major is <${::facts['os']['release']['major']}> and must be 5, 6 or 7")
            }
          }
        }
        'Debian': {
          $_common_files            = [ 'common_account', 'common_auth', 'common_password', 'common_session', 'common_session_noninteractive' ]
          $_common_files_suffix     = undef
          $_add_links               = false

          if $facts['os']['name'] == 'Ubuntu' {
            if !($facts['os']['release']['major'] in ['12.04', '14.04', '16.04']) {
              fail("Ubuntu's os.release.major is <${facts['os']['release']['major']}> and must be 12.04, 14.04, or 16.04")
            }
          } else {
            if !($facts['os']['release']['major'] in ['7', '8']) {
              fail("Debian's os.release.major is <${facts['os']['release']['major']}> and must be 7 or 8")
            }
          }
        }
        'Suse': {
          case $facts['os']['release']['major'] {
            '9': {
              $_common_files        = [ 'other' ]
              $_common_files_suffix = undef
              $_add_links           = false
            }
            '10': {
              $_common_files            = [ 'common_account', 'common_auth', 'common_password', 'common_session' ]
              $_common_files_suffix = undef
              $_add_links           = false
            }
            '11','12','13': {
              $_common_files            = [ 'common_account', 'common_auth', 'common_password', 'common_session' ]
              $_common_files_suffix = '_pc'
              $_add_links           = true
            }
            default : {
              fail("osfamily Suse's os.release.major is <${::facts['os']['release']['major']}> and must be 9, 10, 11, 12 or 13")
            }
          }
        }
        default: {
          fail('Pam is not supported on your osfamily')
        }
      }

      $_common_files.each |$_common_file| {
        file { "pam_${_common_file}${_common_files_suffix}":
          ensure  => file,
          path    => getvar("${_common_file}${_common_files_suffix}_file"),
          content => template("pam/${_common_file}.erb"),
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          require => Package[$package_name],
        }

        if $_add_links == true {
          file { "pam_${_common_file}":
            ensure  => symlink,
            path    => getvar("${_common_file}_file"),
            target  => getvar("${_common_file}${_common_files_suffix}_file"),
            owner   => 'root',
            group   => 'root',
            require => Package[$package_name],
          }
        }
      }
    }

    'Solaris': {
      case $facts['kernelrelease'] {
        '5.9','5.10': {
          file { 'pam_conf':
            ensure  => file,
            path    => $pam_conf_file,
            owner   => 'root',
            group   => 'sys',
            mode    => '0644',
            content => template('pam/other.erb'),
          }
        }
        '5.11': {
          file { 'pam_other':
            ensure  => file,
            path    => $other_file,
            owner   => 'root',
            group   => 'sys',
            mode    => '0644',
            content => template('pam/other.erb'),
          }
        }
        default: {
          fail("osfamily Solaris' kernelrelease is <${facts['kernelrelease']}> and must be 5.9, 5.10 or 5.11")
        }
      }
    }
    default: {
      fail("Pam is only supported on RedHat, SuSE, Debian and Solaris osfamilies. Your osfamily is identified as <${::osfamily}>.")
    }
  }
}
