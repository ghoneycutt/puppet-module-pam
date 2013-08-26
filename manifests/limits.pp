# == Class: pam::limits
#
# Manage PAM limits.conf
#
class pam::limits (
  $config_file  = '/etc/security/limits.conf',
  $limits_d_dir = '/etc/security/limits.d',
) {

  include pam

  file { 'limits_conf':
    ensure  => file,
    path    => $config_file,
    source  => 'puppet:///modules/pam/limits.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['pam_package'],
  }
}
