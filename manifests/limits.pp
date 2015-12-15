# == Class: pam::limits
#
# Manage PAM limits.conf
#
class pam::limits (
  $config_file          = '/etc/security/limits.conf',
  $config_file_lines    = undef,
  $config_file_source   = undef,
  $config_file_mode     = '0640',
  $limits_d_dir         = '/etc/security/limits.d',
  $limits_d_dir_mode    = '0750',
  $purge_limits_d_dir   = false,
) {

  # validate params
  validate_absolute_path($config_file)
  validate_absolute_path($limits_d_dir)

  validate_re($config_file_mode, '^[0-7]{4}$',
    "pam::limits::config_file_mode is <${config_file_mode}> and must be a valid four digit mode in octal notation.")

  validate_re($limits_d_dir_mode, '^[0-7]{4}$',
    "pam::limits::limits_d_dir_mode is <${limits_d_dir_mode}> and must be a valid four digit mode in octal notation.")

  if is_string($purge_limits_d_dir) == true {
    $purge_limits_d_dir_real = str2bool($purge_limits_d_dir)
  } else {
    $purge_limits_d_dir_real = $purge_limits_d_dir
  }
  validate_bool($purge_limits_d_dir_real)

  include ::pam

  if $config_file_lines == undef and $config_file_source == undef {
    $content = template('pam/limits.conf.erb')
  } else {
    # config_file_lines takes priority over config_file_source
    if $config_file_lines == undef {
      $content = undef
      $config_file_source_real = $config_file_source
    } else {
      $config_file_source_real = undef
      validate_array($config_file_lines)
      $content = template('pam/limits.conf.erb')
    }
  }
  if $::osfamily == 'Suse' and $::lsbmajdistrelease == '10'  {
  } else {
    common::mkdir_p { $limits_d_dir: }
    file { 'limits_d':
      ensure  => directory,
      path    => $limits_d_dir,
      owner   => 'root',
      group   => 'root',
      mode    => $limits_d_dir_mode,
      purge   => $purge_limits_d_dir_real,
      recurse => $purge_limits_d_dir_real,
      require => [ Package[$::pam::my_package_name],
                  Common::Mkdir_p[$limits_d_dir],
                  ],
    }
  }
  file { 'limits_conf':
    ensure  => file,
    path    => $config_file,
    source  => $config_file_source_real,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => $config_file_mode,
    require => Package[$::pam::my_package_name],
  }
}
