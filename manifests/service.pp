# == Class: pam::service
#
# Manage PAM file for a specifc service
#
define pam::service (
  $ensure         = 'present',
  $pam_config_dir = '/etc/pam.d',
  $content        = undef,
  $lines          = undef
) {

  include ::pam

  validate_re($ensure, ['^present$', '^absent$'] )

  case $ensure {
    'present': {
      $file_ensure = 'file'
    }
    default: {
      $file_ensure = 'absent'
    }
  }

  if $content and $lines {
    fail('pam::service expects one of the lines or contents parameters to be provided, but not both')
  } elsif $content {
    $my_content = $content
  } elsif $lines {
    $my_content = template('pam/service.erb')
  } else {
    $my_content = undef
  }

  file { "pam.d-service-${name}":
    ensure  => $file_ensure,
    path    => "${pam_config_dir}/${name}",
    content => $my_content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
