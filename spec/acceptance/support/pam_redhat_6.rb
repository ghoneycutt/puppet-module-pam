shared_examples_for 'pam_redhat_6_basic' do
  describe package('pam') do
    it { should be_installed }
  end

  describe file('/etc/pam.d/login') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    expected_content = (<<EXPECTED).split(/\n/)
#%PAM-1.0
auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so
auth       include      system-auth
account    required     pam_nologin.so
account    include      system-auth
account    required     pam_access.so
password   include      system-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
session    optional     pam_console.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    include      system-auth
-session   optional     pam_ck_connector.so
EXPECTED
    it { should contain(expected_content) }
  end

  describe file('/etc/pam.d/sshd') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    expected_content = (<<EXPECTED).split(/\n/)
#%PAM-1.0
auth       required     pam_sepermit.so
auth       include      password-auth
account    required     pam_access.so
account    required     pam_nologin.so
account    include      password-auth
password   include      password-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open env_params
session    optional     pam_keyinit.so force revoke
session    include      password-auth
EXPECTED
    it { should contain(expected_content) }
  end

  describe file('/etc/pam.d/system-auth') do
    it { should be_linked_to '/etc/pam.d/system-auth-ac' }
  end

  describe file('/etc/pam.d/system-auth-ac') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    expected_content = (<<EXPECTED).split(/\n/)
# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth        required      pam_env.so
auth        sufficient    pam_fprintd.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

# Account
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

# Password
password    requisite     pam_cracklib.so try_first_pass retry=3 type=
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

# Session
session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EXPECTED
    it { should contain(expected_content) }
  end

  describe file('/etc/pam.d/password-auth') do
    it { should be_linked_to '/etc/pam.d/password-auth-ac' }
  end

  describe file('/etc/pam.d/password-auth-ac') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    expected_content = (<<EXPECTED).split(/\n/)
# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth       include      system-auth

# Account
account    include      system-auth

# Password
password   include      system-auth

# Session
session    include      system-auth
EXPECTED
    it { should contain(expected_content) }
  end
end
