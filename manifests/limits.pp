# == Class: pam::limits
#
# Manage PAM limits.conf
#
class pam::limits (
  $config_file       = '/etc/security/limits.conf',
  $config_file_mode  = '0640',
  $limits_d_dir      = '/etc/security/limits.d',
  $limits_d_dir_mode = '0750',
) {

  # validate params
  validate_absolute_path($config_file)
  validate_absolute_path($limits_d_dir)

  validate_re($config_file_mode, '^[0-7]{4}$',
    "pam::limits::config_file_mode is <${config_file_mode}> and must be a valid four digit mode in octal notation.")

  validate_re($limits_d_dir_mode, '^[0-7]{4}$',
    "pam::limits::limits_d_dir_mode is <${limits_d_dir_mode}> and must be a valid four digit mode in octal notation.")

  include pam

  # ensure target exists
  # If puppet-module-common is installed, use the function from there
  if defined('common::mkdir_p') {
    common::mkdir_p { $limits_d_dir: }

    file { 'limits_d':
      ensure  => directory,
      path    => $limits_d_dir,
      owner   => 'root',
      group   => 'root',
      mode    => $limits_d_dir_mode,
      require => [ Package[$pam::my_package_name],
                Common::Mkdir_p[$limits_d_dir],
                ],
    }

  } else {

    # Otherwise fallback and just do an exec
    exec { "mkdir_p-${limits_d_dir}":
    command => "mkdir -p ${limits_d_dir}",
      unless  => "test -d ${limits_d_dir}",
      path    => '/bin:/usr/bin',
    }

    file { 'limits_d':
      ensure  => directory,
      path    => $limits_d_dir,
      owner   => 'root',
      group   => 'root',
      mode    => $limits_d_dir_mode,
      require => [ Package[$pam::my_package_name],
                  Exec["mkdir_p-${limits_d_dir}"],
                ],
    }
  }

  file { 'limits_d':
    ensure  => directory,
    path    => $limits_d_dir,
    owner   => 'root',
    group   => 'root',
    mode    => $limits_d_dir_mode,
    require => [ Package[$pam::my_package_name],
                Common::Mkdir_p[$limits_d_dir],
                ],
  }

  file { 'limits_conf':
    ensure  => file,
    path    => $config_file,
    source  => 'puppet:///modules/pam/limits.conf',
    owner   => 'root',
    group   => 'root',
    mode    => $config_file_mode,
    require => Package[$pam::my_package_name],
  }
}
