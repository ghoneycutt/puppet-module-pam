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
    'Solaris': {
      $default_nsswitch_ipnodes   = 'files dns'
      $default_nsswitch_printers  = 'user files'
      $default_nsswitch_auth_attr = 'files'
      $default_nsswitch_prof_attr = 'files'
      $default_nsswitch_project   = 'files'
    }
    default: {
      $default_nsswitch_ipnodes   = undef
      $default_nsswitch_printers  = undef
      $default_nsswitch_auth_attr = undef
      $default_nsswitch_prof_attr = undef
      $default_nsswitch_project   = undef
    }
  }

  if $nsswitch_ipnodes == 'USE_DEFAULTS' {
    $nsswitch_ipnodes_real = $default_nsswitch_ipnodes
  } else {
    $nsswitch_ipnodes_real = $nsswitch_ipnodes
  }

  if $nsswitch_printers == 'USE_DEFAULTS' {
    $nsswitch_printers_real = $default_nsswitch_printers
  } else {
    $nsswitch_printers_real = $nsswitch_printers
  }

  if $nsswitch_auth_attr == 'USE_DEFAULTS' {
    $nsswitch_auth_attr_real = $default_nsswitch_auth_attr
  } else {
    $nsswitch_auth_attr_real = $nsswitch_auth_attr
  }

  if $nsswitch_prof_attr == 'USE_DEFAULTS' {
    $nsswitch_prof_attr_real = $default_nsswitch_prof_attr
  } else {
    $nsswitch_prof_attr_real = $nsswitch_prof_attr
  }

  if $nsswitch_project == 'USE_DEFAULTS' {
    $nsswitch_project_real = $default_nsswitch_project
  } else {
    $nsswitch_project_real = $nsswitch_project
  }

  if $nsswitch_ipnodes_real != undef {
    validate_re($nsswitch_ipnodes_real, '^(files|files dns)$',
      'Valid values for nsswitch_ipnodes are \'files\' and \'files dns\'.')
  }

  if $nsswitch_printers_real != undef {
    validate_re($nsswitch_printers_real, '^(user|user files)$',
      'Valid values for nsswitch_printers are \'user\' and \'user files\'.')
  }

  if $nsswitch_auth_attr_real != undef {
    validate_re($nsswitch_auth_attr_real, '^(files)$',
      'Valid value for nsswitch_auth_attr is \'files\'.')
  }

  if $nsswitch_prof_attr_real != undef {
    validate_re($nsswitch_prof_attr_real, '^(files)$',
      'Valid value for nsswitch_prof_attr is \'files\'.')
  }

  if $nsswitch_project_real != undef {
    validate_re($nsswitch_project_real, '^(files)$',
      'Valid value for nsswitch_project is \'files\'.')
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
