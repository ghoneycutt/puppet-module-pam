# @summary Manages pwhistory.conf settings.
#
# This class configures the /etc/security/pwhistory.conf file.
#
# @param config_file
#   Path to the pwhistory.conf file. Defaults to '/etc/security/pwhistory.conf'.
# @param config_file_owner
#   Owner of the pwhistory.conf file. Defaults to 'root'.
# @param config_file_group
#   Group of the pwhistory.conf file. Defaults to 'root'.
# @param config_file_mode
#   File mode for pwhistory.conf. Defaults to '0644'.
# @param config_file_source
#   Optional: Specifies a source file for pwhistory.conf. If set, ignores template.
# @param config_file_template
#   Optional: Specifies the template to use for pwhistory.conf. Defaults to 'pam/pwhistory.conf.erb'.
# @param remember
#   The number of old passwords to remember. This value will be written to pwhistory.conf.
#   If undef, the 'remember' option will be commented out in the generated config.
# @param enforce_for_root
#   Boolean to enforce password history for the root user. If true, 'enforce_for_root'
#   will be enabled in the config. If false or undef, it will be commented out.
# @param debug
#   Boolean to enable debugging logs. If true, 'debug' will be enabled in the config.
#   If false or undef, it will be commented out.
# @param retry
#   The number of times to prompt for the password. This value will be written to pwhistory.conf.
#   If undef, the 'retry' option will be commented out in the generated config.
# @param file
#   The directory where the last passwords are kept. This value will be written to pwhistory.conf.
#   If undef, the 'file' option will be commented out in the generated config.
#
class pam::pwhistory (
  Stdlib::Absolutepath $config_file        = '/etc/security/pwhistory.conf',
  String[1] $config_file_owner             = 'root',
  String[1] $config_file_group             = 'root',
  Stdlib::Filemode $config_file_mode       = '0644',
  Optional[Stdlib::Filesource] $config_file_source = undef,
  String[1] $config_file_template          = 'pam/pwhistory.conf.erb',
  Optional[Integer[0]] $remember           = undef,
  Optional[Boolean] $enforce_for_root      = undef,
  Optional[Boolean] $debug                 = undef,
  Optional[Integer[1]] $retry              = undef,
  Optional[Stdlib::Absolutepath] $file     = undef,
) {
  include pam

  if $config_file_source {
    $_config_file_content = undef
  } else {
    $_config_file_content = template($config_file_template)
  }

  file { 'pwhistory.conf':
    ensure  => 'file',
    path    => $config_file,
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => $config_file_mode,
    source  => $config_file_source,
    content => $_config_file_content,
    require => Package[$pam::package_name],
  }
}
