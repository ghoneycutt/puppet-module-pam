# == Class: pam::limits::fragment
#
# Places a fragment in $limits_d_dir directory
#
define pam::limits::fragment (
  Optional[String] $source = undef,
  Optional[Array] $list    = undef,
  Enum['file', 'present', 'absent']
    $ensure                = 'file',
) {

  include ::pam
  include ::pam::limits

  if $::osfamily == 'Suse' and $::operatingsystemmajrelease == '10' {
    fail('You can not use pam::limits::fragment together with Suse 10.x releases')
  }

  # must specify source or list
  if $ensure != 'absent' and ! $source and ! $list {
    fail('pam::limits::fragment must specify source or list.')
  }

  # list takes priority if you specify both
  # use the template if a list is provided
  if $list {
    $source_real = undef
    $content = template('pam/limits_fragment.erb')
  } else {
    $source_real = $source
    $content = undef
  }

  file { "${pam::limits::limits_d_dir}/${name}.conf":
    ensure  => $ensure,
    source  => $source_real,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$pam::package_name],
  }
}
