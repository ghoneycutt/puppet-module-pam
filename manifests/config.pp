# == Class: pam::config
#
# Manage PAM file for a specifc service
#
class pam::config (
  $pam_config_dir = '/etc/pam.d/',
  $service        = undef,
  $content        = undef,
) {

  include pam

  if $service != undef {

    file { $service:
      ensure  => file,
      path    => "${pam_config_dir}${service}",
      content => $content,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }
}
