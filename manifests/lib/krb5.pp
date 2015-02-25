class pam::lib::krb5 (
  $ensure  = 'installed',
  $package = undef
) {

  if $package {
    $my_package = $package
  } else {
    case $::osfamily {
    'RedHat': {
        case $::operatingsystemmajrelease {
          '5','6','7': {
            $my_package = 'pam_krb5'
          }
          default: {
            fail("a custom PAM Kerberos5 module package is required for ${::osfamily} release ${::operatingsystemmajrelease}")
          }
        }
      }
    'Debian': {
        case $::lsbdistid{
          'Ubuntu': {
            case $::lsbdistrelease {
              '12.04','14.04': {
                $my_package = 'libpam-krb5'
              }
              default: {
                fail("a custom PAM Kerberos5 module package is required for ${::osfamily} release ${::operatingsystemmajrelease}")
              }
            }
          }
          default:{
            case $::operatingsystemmajrelease {
              '6': {
                $my_package = 'libpam-krb5'
              }
              default: {
                fail("a custom PAM Kerberos5 module package is required for ${::osfamily} release ${::operatingsystemmajrelease}")
              }
            }
          }
        }
      }
    'Suse':{
      case $::lsbmajdistrelease {
        '9','10','11','12': {
          $my_package = 'pam_krb5'
        }
        default: {
          fail("a custom PAM Kerberos5 module package is required for ${::osfamily} release ${::operatingsystemmajrelease}")
        }
      }
    }
    # 'Solaris':{
    #   # No packages for Solaris
    # }
    default:{
      fail("a custom PAM Kerberos5 module package is required for ${::osfamily}")
    }
  }
  }

  package{$my_package:
    ensure => $ensure,
  }

}
