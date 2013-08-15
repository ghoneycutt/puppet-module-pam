# # Class: pam::limits::fragment #
#
# Places a fragment in $limits_d_dir directory
#
# ## Parameters ##
#
# source
# ------
# Path to the fragment file
#
# - *Required*
#
# ## Example usage ##
# # Add the file example.conf in the pam module to the limits_d_dir with the name "80-nproc.conf"
# pam::limits::fragment { '80-nproc':
#   #source => "puppet:///modules/pam/limits.nproc",
#   content => '* soft nofile 2048',
# }
#


in hiera
---
common::users:
  80-nproc:
    content:
      - '* soft nofile 2048'
      - '* hard nofile 8192'


define pam::limits::fragment (
  $content,
) {

  include pam
  include pam::limits

  file { "${pam::limits::limits_d_dir}/${name}.conf":
    ensure  => file,
    #source => $source,
    content => $line,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['pam_package'],
  }
}
