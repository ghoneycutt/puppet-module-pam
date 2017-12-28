# == Class: pam::limits
#
# Manage PAM limits.conf
#
class pam::limits (
  Stdlib::Absolutepath $config_file    = '/etc/security/limits.conf',
  Optional[Array] $config_file_lines   = undef,
  Optional[String] $config_file_source = undef,
  Stdlib::Filemode $config_file_mode   = '0640',
  Stdlib::Absolutepath $limits_d_dir   = '/etc/security/limits.d',
  Stdlib::Filemode $limits_d_dir_mode  = '0750',
  Boolean $purge_limits_d_dir          = false,
) {

  include ::pam

  if $config_file_lines or $config_file_source {
    # config_file_lines takes priority over config_file_source
    if $config_file_lines {
      $config_file_source_real = undef
      $content = template('pam/limits.conf.erb')
    } else {
      $content = undef
      $config_file_source_real = $config_file_source
    }
  } else {
    $content = template('pam/limits.conf.erb')
    $config_file_source_real = undef
  }
  if $::osfamily == 'Suse' and $::operatingsystemmajrelease == '10'  {
  } else {
    common::mkdir_p { $limits_d_dir: }
    file { 'limits_d':
      ensure  => directory,
      path    => $limits_d_dir,
      owner   => 'root',
      group   => 'root',
      mode    => $limits_d_dir_mode,
      purge   => $purge_limits_d_dir,
      recurse => $purge_limits_d_dir,
      require => [ Package[$::pam::package_name],
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
    require => Package[$::pam::package_name],
  }
}
