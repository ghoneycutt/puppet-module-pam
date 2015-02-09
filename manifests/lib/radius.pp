class pam::lib::radius (
  $ensure  = 'installed',
  $package = undef
) {

  include pam

  if $package {
    $my_package = $package
  } else {
    case $::osfamily {
      'RedHat': {
        $my_package = 'pam_radius'
      }
      'Debian': {
        $my_package = 'libpam-radius-auth'
      }
      'Suse':{
        $my_package = 'pam_radius'
      }
      # 'Solaris':{
      #   # No packages for Solaris
      # }
      default:{
        fail("a custom PAM RADIUS module package is required for ${::osfamily}")
      }
    }
  }

  package{$my_package:
    ensure => $ensure,
  }

}