# # Class: pam::limits::fragment #
#
# Places a fragment in $limits_d_dir directory
#
# ## Example usage ##
# #Add the file example.conf in the pam module to the limits_d_dir with the name "80-nproc.conf"
# pam::limits::fragment { '80-nproc':
#   source => "puppet:///modules/pam/example.conf",
# }
#
# ## Parameters ##
#
# source
# ------
# Path to the fragment file
#
# - *Required*
#
define pam::limits::fragment (
  $source,
) {

  include pam
  include pam::limits

  file { "${pam::limits::limits_d_dir}/${name}.conf":
    ensure  => file,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['pam_package'],
  }
}
