# == Class: pam::service
#
# Manage PAM file for a specifc service
#
# === Parameters
#
# [*auth_directives*]
#   An array of hashes with directives for the auth type
#   The hash must include the following keys
#     - control
#     - module-path
#     - module-arguments
#
# [*account_directives*]
#   An array of hashes with directives for the account type
#   The hash must include the following keys
#     - control
#     - module-path
#     - module-arguments
#
# [*session_directives*]
#   An array of hashes with directives for the session type
#   The hash must include the following keys
#     - control
#     - module-path
#     - module-arguments
#
# [*password_directives*]
#   An array of hashes with directives for the password type
#   The hash must include the following keys
#     - control
#     - module-path
#     - module-arguments
#
# === Examples
# pam::service {'ftp':
#    auth_directives => [{'control' => 'required',
#                         'module-path' => 'pam_nologin.so'
#                         'module-arguments' => 'no_warn'}]
# }
#
#


define pam::service (
  $pam_config_dir = '/etc/pam.d',
  $auth_directives = [],
  $account_directives = [],
  $session_directives = [],
  $password_directives = []
) {

  include pam

  validate_pam_directives($auth_directives)
  validate_pam_directives($account_directives)
  validate_pam_directives($session_directives)
  validate_pam_directives($password_directives)

  file { "pam.d-service-${name}":
    ensure  => file,
    path    => "${pam_config_dir}/${name}",
    content => template('pam/pam_service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
