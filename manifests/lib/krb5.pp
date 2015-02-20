class pam::lib::krb5 (
  $ensure  = 'installed',
  $package = undef
) {

  if $package {
    $my_package = $package
  } else {
    case $::osfamily {
    'RedHat': {
      $my_package = 'pam_krb5'
    }
    'Debian': {
      $my_package = 'libpam-krb5'
    }
    'Suse':{
      $my_package = 'pam_krb5'
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
