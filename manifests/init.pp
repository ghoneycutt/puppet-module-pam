# == Class: nsswitch
#
# This module manages nsswitch.
#
class nsswitch (
  $config_file              = '/etc/nsswitch.conf',
  $ensure_ldap              = 'absent',
  $ensure_vas               = 'absent',
  $vas_nss_module_passwd    = 'vas4',
  $vas_nss_module_group     = 'vas4',
  $vas_nss_module_automount = 'nis',
  $vas_nss_module_netgroup  = 'nis',
  $vas_nss_module_aliases   = '',
  $vas_nss_module_services  = '',
  $passwd                   = 'USE_DEFAULTS',
  $shadow                   = 'USE_DEFAULTS',
  $group                    = 'USE_DEFAULTS',
  $hosts                    = 'USE_DEFAULTS',
  $automount                = 'USE_DEFAULTS',
  $services                 = 'USE_DEFAULTS',
  $bootparams               = 'USE_DEFAULTS',
  $aliases                  = 'USE_DEFAULTS',
  $publickey                = 'USE_DEFAULTS',
  $netgroup                 = 'USE_DEFAULTS',
  $nsswitch_ipnodes         = 'USE_DEFAULTS',
  $nsswitch_printers        = 'USE_DEFAULTS',
  $nsswitch_auth_attr       = 'USE_DEFAULTS',
  $nsswitch_prof_attr       = 'USE_DEFAULTS',
  $nsswitch_project         = 'USE_DEFAULTS',
) {

  validate_absolute_path($config_file)
  validate_re($ensure_ldap, '^(present|absent)$',
    'Valid values for ensure_ldap are \'absent\' and \'present\'.')
  validate_re($ensure_vas, '^(present|absent)$',
    'Valid values for ensure_vas are \'absent\' and \'present\'.')
  validate_string($vas_nss_module_passwd)
  validate_string($vas_nss_module_group)
  validate_string($vas_nss_module_automount)
  validate_string($vas_nss_module_netgroup)
  validate_string($vas_nss_module_aliases)
  validate_string($vas_nss_module_services)

  case $::osfamily {
    'Debian','Suse': {
      $default_passwd             = 'files'
      $default_shadow             = 'files'
      $default_group              = 'files'
      $default_hosts              = 'files dns'
      $default_automount          = 'files'
      $default_services           = 'files'
      $default_bootparams         = 'files'
      $default_aliases            = 'files'
      $default_publickey          = 'files'
      $default_netgroup           = 'files'
      $default_nsswitch_ipnodes   = undef
      $default_nsswitch_printers  = undef
      $default_nsswitch_auth_attr = undef
      $default_nsswitch_prof_attr = undef
    }
    'RedHat': {
      if $::operatingsystemmajrelease == '7' {
        $default_passwd     = 'files sss'
        $default_shadow     = 'files sss'
        $default_group      = 'files sss'
        $default_hosts      = 'files dns myhostname'
        $default_automount  = 'files sss'
        $default_services   = 'files sss'
        $default_bootparams = 'nisplus [NOTFOUND=return] files'
        $default_aliases    = 'files nisplus'
        $default_publickey  = 'nisplus'
        $default_netgroup   = 'files sss'
      } else {
        $default_passwd     = 'files'
        $default_shadow     = 'files'
        $default_group      = 'files'
        $default_hosts      = 'files dns'
        $default_automount  = 'files'
        $default_services   = 'files'
        $default_bootparams = 'files'
        $default_aliases    = 'files'
        $default_publickey  = 'files'
        $default_netgroup   = 'files'
      }

      $default_nsswitch_ipnodes   = undef
      $default_nsswitch_printers  = undef
      $default_nsswitch_auth_attr = undef
      $default_nsswitch_prof_attr = undef
    }
    'Solaris': {
      $default_passwd             = 'files'
      $default_shadow             = 'files'
      $default_group              = 'files'
      $default_hosts              = 'files dns'
      $default_automount          = 'files'
      $default_services           = 'files'
      $default_bootparams         = 'files'
      $default_aliases            = 'files'
      $default_publickey          = 'files'
      $default_netgroup           = 'files'
      $default_nsswitch_ipnodes   = 'files dns'
      $default_nsswitch_printers  = 'user files'
      $default_nsswitch_auth_attr = 'files'
      $default_nsswitch_prof_attr = 'files'
      $default_nsswitch_project   = 'files'
    }
    default: {
      fail("nsswitch supports osfamilies Debian, RedHat, Solaris and Suse. Detected osfamily is <${::osfamily}>.")
    }
  }

  if $passwd == 'USE_DEFAULTS' {
    $passwd_real = $default_passwd
  } else {
    $passwd_real = $passwd
  }
  validate_string($passwd_real)

  if $shadow == 'USE_DEFAULTS' {
    $shadow_real = $default_shadow
  } else {
    $shadow_real = $shadow
  }
  validate_string($shadow_real)

  if $group == 'USE_DEFAULTS' {
    $group_real = $default_group
  } else {
    $group_real = $group
  }
  validate_string($group_real)

  if $hosts == 'USE_DEFAULTS' {
    $hosts_real = $default_hosts
  } else {
    $hosts_real = $hosts
  }
  validate_string($hosts_real)

  if $automount == 'USE_DEFAULTS' {
    $automount_real = $default_automount
  } else {
    $automount_real = $automount
  }
  validate_string($automount_real)

  if $services == 'USE_DEFAULTS' {
    $services_real = $default_services
  } else {
    $services_real = $services
  }
  validate_string($services_real)

  if $bootparams == 'USE_DEFAULTS' {
    $bootparams_real = $default_bootparams
  } else {
    $bootparams_real = $bootparams
  }
  validate_string($bootparams_real)

  if $aliases == 'USE_DEFAULTS' {
    $aliases_real = $default_aliases
  } else {
    $aliases_real = $aliases
  }
  validate_string($aliases_real)

  if $publickey == 'USE_DEFAULTS' {
    $publickey_real = $default_publickey
  } else {
    $publickey_real = $publickey
  }
  validate_string($publickey_real)

  if $netgroup == 'USE_DEFAULTS' {
    $netgroup_real = $default_netgroup
  } else {
    $netgroup_real = $netgroup
  }
  validate_string($netgroup_real)

  if $nsswitch_ipnodes == 'USE_DEFAULTS' {
    $nsswitch_ipnodes_real = $default_nsswitch_ipnodes
  } else {
    $nsswitch_ipnodes_real = $nsswitch_ipnodes
  }

  if $nsswitch_ipnodes_real != undef {
    validate_string($nsswitch_ipnodes_real)
  }

  if $nsswitch_printers == 'USE_DEFAULTS' {
    $nsswitch_printers_real = $default_nsswitch_printers
  } else {
    $nsswitch_printers_real = $nsswitch_printers
  }

  if $nsswitch_printers_real != undef {
    validate_string($nsswitch_printers_real)
  }

  if $nsswitch_auth_attr == 'USE_DEFAULTS' {
    $nsswitch_auth_attr_real = $default_nsswitch_auth_attr
  } else {
    $nsswitch_auth_attr_real = $nsswitch_auth_attr
  }

  if $nsswitch_auth_attr_real != undef {
    validate_string($nsswitch_auth_attr_real)
  }

  if $nsswitch_prof_attr == 'USE_DEFAULTS' {
    $nsswitch_prof_attr_real = $default_nsswitch_prof_attr
  } else {
    $nsswitch_prof_attr_real = $nsswitch_prof_attr
  }

  if $nsswitch_prof_attr_real != undef {
    validate_string($nsswitch_prof_attr_real)
  }

  if $nsswitch_project == 'USE_DEFAULTS' {
    $nsswitch_project_real = $default_nsswitch_project
  } else {
    $nsswitch_project_real = $nsswitch_project
  }

  if $nsswitch_project_real != undef {
    validate_string($nsswitch_project_real)
  }

  file { 'nsswitch_config_file':
    ensure  => file,
    path    => $config_file,
    content => template('nsswitch/nsswitch.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
