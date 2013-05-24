# # Class: pam::accesslogin #
# Manages login access
# See PAM_ACCESS(8)
# 
# ## Parameters ##
# 
# access_conf_path
# ----------------
# Path to access.conf.
# 
# - *Default*: '/etc/security/access.conf'
# 
# access_conf_owner
# -----------------
# Owner of access.conf.
# 
# - *Default*: 'root'
# 
# access_conf_group
# -----------------
# Group of access.conf.
# 
# - *Default*: 'root'
# 
# access_conf_mode
# ----------------
# Mode of access.conf.
# 
# - *Default*: '0644'
# 
# access_conf_template
# --------------------
# Content template of access.conf.
# 
# - *Default*: 'pam/access.conf.erb'
# 
# allowed
# -------
# Array of users and groups allowed to log in.
#
# - *Default*: root
#
class pam::accesslogin (
  $access_conf_path     = '/etc/security/access.conf',
  $access_conf_owner    = 'root',
  $access_conf_group    = 'root',
  $access_conf_mode     = '0644',
  $access_conf_template = 'pam/access.conf.erb',
  $allowed              = 'root',
) {

  require 'pam'

  file { 'access_conf':
    ensure  => file,
    path    => $access_conf_path,
    content => template($access_conf_template),
    owner   => $access_conf_owner,
    group   => $access_conf_group,
    mode    => $access_conf_mode,
    require => Package['pam_package'],
  }
}
