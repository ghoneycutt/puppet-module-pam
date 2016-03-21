class pam::lib::krb5 (
  $package_ensure = 'installed',
  $package_name   = 'USE_DEFAULTS'
) {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '5','6','7': {
          $default_package_name = 'pam_krb5'
        }
        default: {
          fail("pam::lib::krb5 supports EL 5, 6 and 7. Your operatingsystemmajrelease is identified as <${::operatingsystemmajrelease}>.")
        }
      }
    }
    'Debian': {
      case $::lsbdistid {
        'Ubuntu': {
          case $::lsbdistrelease {
            '12.04','14.04': {
              $default_package_name = 'libpam-krb5'
            }
            default: {
              fail("pam::lib::krb5 supports Ubuntu 12.04 and 14.04. Your lsbdistrelease is identified as <${::lsbdistrelease}>.")
            }
          }
        }
        default:{
          case $::operatingsystemmajrelease {
            '6': {
              $default_package_name = 'libpam-krb5'
            }
            default: {
              fail("pam::lib::krb5 supports Debian 6. Your operatingsystemmajrelease is identified as <${::operatingsystemmajrelease}>.")
            }
          }
        }
      }
    }
    'Suse': {
      case $::lsbmajdistrelease {
        '9','10','11','12': {
          $default_package_name = 'pam_krb5'
        }
        default: {
          fail("pam::lib::krb5 supports Suse 10, 11, and 12. Your lsbmajdistrelease is identified as <${::lsbmajdistrelease}>.")
        }
      }
    }
    default: {
      fail('pam::lib::krb5 does not have a default for your system. Please specify a package at pam::lib::krb5::package_name.')
    }
  }

  if $package_name == 'USE_DEFAULTS' {
    $package_name_real = $default_package_name
  } else {
    $package_name_real = $package_name
  }

  validate_string($package_name_real)
  validate_string($package_ensure)

  package{'pam_lib_krb5':
    ensure => $package_ensure,
    name   => $package_name_real,
  }

}
