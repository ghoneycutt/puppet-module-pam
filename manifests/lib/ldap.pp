class pam::lib::ldap (
  $ensure  = 'installed',
  $package = undef
) {

  if $package {
    $my_package = $package
  } else {
    case $::osfamily {
      'RedHat': {
        $my_package = 'pam_ldap'
      }
      'Debian': {
        $my_package = 'libpam-ldap'
      }
      'Suse':{
        $my_package = 'pam_ldap'
      }
      # 'Solaris':{
      #   # No packages for Solaris
      # }
      default:{
        fail("a custom PAM ldap module package is required for ${::osfamily}")
      }
    }
  }

  package{$my_package:
    ensure => $ensure,
  }

}
