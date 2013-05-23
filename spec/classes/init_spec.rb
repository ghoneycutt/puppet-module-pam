require 'spec_helper'

describe 'pam' do

	describe 'packages' do

    context 'with class defaults on rhel 5' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end

      it do
        should contain_package('pam_package').with({
          'ensure' => 'installed',
          'name'   => ['pam', 'util-linux'],
        })
      end
    end

    context 'with class defaults on rhel 6' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '6',
        }
      end

      it do
        should contain_package('pam_package').with({
          'ensure' => 'installed',
          'name'   => 'pam',
        })
      end
    end

    context 'with specifying package_name on valid platform' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end

			let(:params) { {:package_name => 'foo'} }

			it do
    	  should contain_package('pam_package').with({
          'ensure' => 'installed',
					'name'   => 'foo',
				})
			end
		end

    context 'with unsupported version of redhat' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '4',
        }
      end
      it { expect { subject }.to raise_error(/pam is only supported on EL 5 and 6. Your lsbmajdistrelease is identified as 4/ ) }
    end

    context 'with unsupported osfamily' do
      let :facts do
        {
          :osfamily          => 'gentoo',
        }
      end
      it { expect { subject }.to raise_error(/pam is only supported on RedHat systems. Your osfamily is identified as gentoo/ ) }
    end
	end

	describe 'system-auth-ac config file' do

    context 'defaults for rhel 5' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end
      it do
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      end
      it 'should contain File[pam_system_auth_ac] with correct content' do
        should contain_file('pam_system_auth_ac').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

account     required      pam_unix.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

password    requisite     pam_cracklib.so try_first_pass retry=3
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
})
      end
    end
    context 'defaults for rhel 6' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '6',
        }
      end

      it do
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      end

      it 'should contain File[pam_system_auth_ac] with correct content' do
        should contain_file('pam_system_auth_ac').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
auth        required      pam_env.so
auth        sufficient    pam_fprintd.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

password    requisite     pam_cracklib.so try_first_pass retry=3 type=
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
})
      end
    end

    context 'with unsupported version of redhat' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '4',
        }
      end
      it { expect { subject }.to raise_error(/pam is only supported on EL 5 and 6. Your lsbmajdistrelease is identified as 4/ ) }
    end

    context 'with unsupported osfamily' do
      let :facts do
        {
          :osfamily          => 'gentoo',
        }
      end
      it { expect { subject }.to raise_error(/pam is only supported on RedHat systems. Your osfamily is identified as gentoo/ ) }
    end
	end

  describe 'system-auth config file' do
    context 'defaults for rhel 5' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end
      it do
        should contain_file('pam_system_auth').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/system-auth',
          'owner'  => 'root',
          'group'  => 'root',
        })
      end
    end
  end

  describe 'login config file' do
    context 'defaults for rhel 5' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end
      it do
        should contain_file('pam_d_login').with({
          'ensure' => 'file',
          'path'   => '/etc/pam.d/login',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      end

      it 'should contain File[pam_d_login] with correct content' do
        should contain_file('pam_d_login').with_content(
%{#%PAM-1.0
auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so
auth       include      system-auth
account    required     pam_nologin.so
account    include      system-auth
account    required     pam_access.so
password   include      system-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    optional     pam_keyinit.so force revoke
session    required     pam_loginuid.so
session    include      system-auth
session    optional     pam_console.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open
})
      end
    end

    context 'defaults for rhel 6' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '6',
        }
      end
      it do
        should contain_file('pam_d_login').with({
          'ensure' => 'file',
          'path'   => '/etc/pam.d/login',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      end
      it 'should contain File[pam_d_login] with correct content' do
        should contain_file('pam_d_login').with_content(
%{#%PAM-1.0
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
})
      end
    end

    context 'with unsupported version of redhat' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '4',
        }
      end
      it { expect { subject }.to raise_error(/pam is only supported on EL 5 and 6. Your lsbmajdistrelease is identified as 4/ ) }
    end

    context 'with unsupported osfamily' do
      let :facts do
        {
          :osfamily          => 'gentoo',
        }
      end
      it { expect { subject }.to raise_error(/pam is only supported on RedHat systems. Your osfamily is identified as gentoo/ ) }
    end
  end

  describe 'sshd config file' do
    context 'defaults for rhel 5' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end
      it do
        should contain_file('pam_d_sshd').with({
          'ensure' => 'file',
          'path'   => '/etc/pam.d/sshd',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      end
      it 'should contain File[pam_d_sshd] with correct content' do
        should contain_file('pam_d_sshd').with_content(
%{#%PAM-1.0
auth       include      system-auth
account    required     pam_nologin.so
account    include      system-auth
account    required     pam_access.so
password   include      system-auth
session    optional     pam_keyinit.so force revoke
session    include      system-auth
session    required     pam_loginuid.so
})
      end
    end

    context 'defaults for rhel 6' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '6',
        }
      end
      it do
        should contain_file('pam_d_sshd').with({
          'ensure' => 'file',
          'path'   => '/etc/pam.d/sshd',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      end
      it 'should contain File[pam_d_sshd] with correct content' do
        should contain_file('pam_d_sshd').with_content(
%{#%PAM-1.0
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
})
      end
    end

    context 'with specifying pam_d_login_oracle_options on valid platform' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end
			let(:params) { {:pam_d_login_oracle_options => ['foo','bar']} }

      it 'should contain File[pam_d_login] with correct content' do
        should contain_file('pam_d_login').with_content(
%{#%PAM-1.0
auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so
auth       include      system-auth
account    required     pam_nologin.so
account    include      system-auth
account    required     pam_access.so
password   include      system-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    optional     pam_keyinit.so force revoke
session    required     pam_loginuid.so
session    include      system-auth
session    optional     pam_console.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open
# oracle options
foo
bar
})
      end
    end

    context 'with unsupported version of redhat' do
      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '4',
        }
      end
      it { expect { subject }.to raise_error(/pam is only supported on EL 5 and 6. Your lsbmajdistrelease is identified as 4/ ) }
    end

    context 'with unsupported osfamily' do
      let :facts do
        {
          :osfamily          => 'gentoo',
        }
      end
      it { expect { subject }.to raise_error(/pam is only supported on RedHat systems. Your osfamily is identified as gentoo/ ) }
    end

  end

end
