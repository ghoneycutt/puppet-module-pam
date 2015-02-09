class pam::lib::ccreds (
  $ensure  = 'installed',
  $package = undef
) {

  include pam

  if $package {
    $my_package = $package
  } else {
    case $::osfamily {
      'RedHat': {
        $my_package = 'pam_ccreds'
      }
      'Debian': {
        $my_package = 'libpam-ccreds'
      }
      'Suse':{
        $my_package = 'pam_ccreds'
      }
      # 'Solaris':{
      #   # No packages for Solaris
      # }
      default:{
        fail("a custom PAM ccreds module package is required for ${::osfamily}")
      }
    }
  }

  package{$my_package:
    ensure => $ensure,
  }

}