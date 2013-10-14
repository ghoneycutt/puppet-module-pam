# == Class: pam::service
#
# Manage PAM file for a specifc service
#
define pam::service (
  $pam_config_dir = '/etc/pam.d/',
  $content        = undef,
) {

  include pam

  file { "pam.d-service-${name}":
    ensure  => file,
    path    => "${pam_config_dir}${name}",
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
