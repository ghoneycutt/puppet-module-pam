# == Class: pam::limits::fragment
#
# Places a fragment in $limits_d_dir directory
#
define pam::limits::fragment (
  $source = 'UNSET',
  $list   = undef,
) {

  include pam
  include pam::limits
  if $::osfamily == 'Suse' and $::lsbmajdistrelease == '10' {
    notify { 'Suse 10.x release does not support PAM fragments. You must use pam::limits::config_file_lines instead.': }
  } else {
    # must specify source or list
    if $source == 'UNSET' and $list == undef {
      fail('pam::limits::fragment must specify source or list.')
    }

    # list takes priority if you specify both
    if $list == undef {
      $source_real = $source
    } else {
      $source_real = undef
    }

    # use the template if a list is provided
    if $list == undef {
      $content = undef
    } else {
      validate_array($list)
      $content = template('pam/limits_fragment.erb')
    }

    file { "${pam::limits::limits_d_dir}/${name}.conf":
      ensure  => file,
      source  => $source_real,
      content => $content,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package[$pam::my_package_name],
    }
  }
}
