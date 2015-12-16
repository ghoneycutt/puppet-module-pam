# == Class: pam::limits::fragment
#
# Places a fragment in $limits_d_dir directory
#
define pam::limits::fragment (
  $source = 'UNSET',
  $list   = undef,
  $ensure = 'file',
) {

  include ::pam
  include ::pam::limits

  if $::osfamily == 'Suse' and $::lsbmajdistrelease == '10' {
    fail('You can not use pam::limits::fragment together with Suse 10.x releases')
  }

  # must specify source or list
  if $ensure != 'absent' and $source == 'UNSET' and $list == undef {
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

  validate_re($ensure, ['^file$', '^present$', '^absent$'],
      "pam::limits::fragment::ensure <${ensure}> and must be either 'file', 'present' or 'absent'.")

  file { "${pam::limits::limits_d_dir}/${name}.conf":
    ensure  => $ensure,
    source  => $source_real,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$pam::my_package_name],
  }
}
