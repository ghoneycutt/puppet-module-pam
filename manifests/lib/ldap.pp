class pam::lib::ldap (
  $package_ensure = 'installed',
  $package_name   = 'USE_DEFAULTS'
) {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '5','6','7': {
          $default_package_name = 'pam_ldap'
        }
        default: {
          fail("pam::lib::ldap supports EL 5, 6 and 7. Your operatingsystemmajrelease is identified as <${::operatingsystemmajrelease}>.")
        }
      }
    }
    'Debian': {
      case $::lsbdistid {
        'Ubuntu': {
          case $::lsbdistrelease {
            '12.04','14.04': {
              $default_package_name = 'libpam-ldap'
            }
            default: {
              fail("pam::lib::ldap supports Ubuntu 12.04 and 14.04. Your lsbdistrelease is identified as <${::lsbdistrelease}>.")
            }
          }
        }
        default:{
          case $::operatingsystemmajrelease {
            '6': {
              $default_package_name = 'libpam-ldap'
            }
            default: {
              fail("pam::lib::ldap supports Debian 6. Your operatingsystemmajrelease is identified as <${::operatingsystemmajrelease}>.")
            }
          }
        }
      }
    }
    'Suse': {
      case $::lsbmajdistrelease {
        '9','10','11','12': {
          $default_package_name = 'pam_ldap'
        }
        default: {
          fail("pam::lib::ldap supports Suse 10, 11, and 12. Your lsbmajdistrelease is identified as <${::lsbmajdistrelease}>.")
        }
      }
    }
    default: {
      fail('pam::lib::ldap does not have a default for your system. Please specify a package at pam::lib::ldap::package_name.')
    }
  }

  if $package_name == 'USE_DEFAULTS' {
    $package_name_real = $default_package_name
  } else {
    $package_name_real = $package_name
  }

  validate_string($package_name_real)
  validate_string($package_ensure)

  package{'pam_lib_ldap':
    ensure => $package_ensure,
    name   => $package_name_real,
  }

}
