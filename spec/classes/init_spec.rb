require 'spec_helper'
describe 'pam' do

  describe 'on unsupported platforms' do
    context 'with defaults params on osfamily RedHat 4' do
      let(:facts) do
        { :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '4',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error,/Pam is only supported on EL 5, 6 and 7. Your operatingsystemmajrelease is identified as <4>./)
      end
    end

    context 'with defaults params on osfamily Suse 8' do
      let(:facts) do
        { :osfamily          => 'Suse',
          :lsbmajdistrelease => '8',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error,/Pam is only supported on Suse 10 and 11. Your lsbmajdistrelease is identified as <8>./)
      end
    end

    context 'with defaults params on osfamily Debian' do
      let(:facts) do
        { :osfamily          => 'Debian',
          :lsbmajdistrelease => '7',
          :lsbdistid         => 'Debian',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error,/Pam is only supported on lsbdistid Ubuntu of the Debian osfamily. Your lsbdistid is <Debian>./)
      end
    end

    context 'with defaults params on Ubuntu 10.04 LTS' do
      let(:facts) do
        { :osfamily       => 'Debian',
          :lsbdistrelease => '10.04',
          :lsbdistid      => 'Ubuntu',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error,/Pam is only supported on Ubuntu 12.04. Your lsbdistrelease is identified as <10.04>./)
      end
    end

    context 'with defaults params on Solaris 8' do
      let(:facts) do
        { :osfamily      => 'Solaris',
          :kernelrelease => '5.8',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error,/Pam is only supported on Solaris 9, 10 and 11. Your kernelrelease is identified as <5.8>./)
      end
    end
  end

  describe 'packages' do

    context 'with default params on osfamily RedHat with operatingsystemmajrelease 5' do
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      ['pam', 'util-linux'].each do |pkg|
        it {
          should contain_package(pkg).with({
            'ensure' => 'installed',
          })
        }
      end
    end

    context 'with default params on osfamily RedHat with operatingsystemmajrelease 6' do
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '6',
        }
      end

      it do
        should contain_package('pam').with({
          'ensure' => 'installed',
        })
      end
    end

    context 'with default params on osfamily RedHat with operatingsystemmajrelease 7' do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '7',
        }
      end

      it do
        should contain_package('pam').with({
          'ensure' => 'installed',
        })
      end
    end

    context 'with default params on osfamily Suse with lsbmajdistrelease 9' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '9',
        }
      end

      ['pam', 'pam-modules'].each do |pkg|
        it {
          should contain_package(pkg).with({
            'ensure' => 'installed',
          })
        }
      end
    end

    context 'with default params on osfamily Suse with lsbmajdistrelease 10' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '10',
        }
      end

      it {
        should contain_package('pam').with({
          'ensure' => 'installed',
        })
      }
    end

    context 'with default params on osfamily Suse with lsbmajdistrelease 11' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '11',
        }
      end

      it {
        should contain_package('pam').with({
          'ensure' => 'installed',
        })
      }
    end

    context 'with default params on Solaris 9' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.9',
        }
      end

      it { should_not contain_package('pam_package') }
    end

    context 'with default params on Solaris 10' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.10',
        }
      end

      it { should_not contain_package('pam_package') }
    end

    context 'with default params on Solaris 11' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.11',
        }
      end

      it { should_not contain_package('pam_package') }
    end

    context 'with specifying package_name on valid platform' do
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      let(:params) { {:package_name => 'foo'} }

      it {
        should contain_package('foo').with({
          'ensure' => 'installed',
        })
      }
    end
  end

  describe 'config files' do

    context 'with specifying services param' do
      let (:params) { {:services => { 'testservice' => { 'content' => 'foo' } } } }
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '9',
        }
      end

      it {
        should contain_file('pam.d-service-testservice').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/testservice',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam.d-service-testservice').with_content('foo') }
    end

    context 'with specifying services param as invalid type (non-hash)' do
      let (:params) { {:services => ['not', 'a', 'hash'] } }
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '9',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error)
      end

    end

    context 'with default params on osfamily RedHat with operatingsystemmajrelease 5' do
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      it {
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_system_auth_ac').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so

# Account
account     required      pam_unix.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     required      pam_permit.so

# Password
password    requisite     pam_cracklib.so try_first_pass retry=3
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

# Session
session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
")
      }

      it {
        should contain_file('pam_system_auth').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/system-auth',
          'target' => 'system-auth-ac',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it { should_not contain_file('pam_password_auth_ac') }

      it { should_not contain_file('pam_password_auth') }

      it_behaves_like "pam_d_login-el5"
      it_behaves_like "pam_d_sshd-el5"

      it { should_not contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so/) }
    end

    context 'with default params on osfamily RedHat with operatingsystemmajrelease 6' do
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '6',
        }
      end

      it {
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }
      it { should contain_file('pam_system_auth_ac').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth        required      pam_env.so
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
")
      }

      it {
        should contain_file('pam_system_auth').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/system-auth',
          'target' => 'system-auth-ac',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it {
        should contain_file('pam_password_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/password-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_password_auth_ac').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth       include      system-auth

# Account
account    include      system-auth

# Password
password   include      system-auth

# Session
session    include      system-auth
")
      }

      it {
        should contain_file('pam_password_auth').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/password-auth',
          'target' => 'password-auth-ac',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it_behaves_like "pam_d_login-el6"
      it_behaves_like "pam_d_sshd-el6"

      it { should_not contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so/) }
    end

    context 'with default params on osfamily RedHat with operatingsystemmajrelease 7' do
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '7',
        }
      end

      it {
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }
      it { should contain_file('pam_system_auth_ac').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        required      pam_deny.so

# Account
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so

# Password
password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

# Session
session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session    optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
")
      }

      it {
        should contain_file('pam_system_auth').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/system-auth',
          'target' => 'system-auth-ac',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it {
        should contain_file('pam_password_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/password-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_password_auth_ac').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth       include      system-auth

# Account
account    include      system-auth

# Password
password   include      system-auth

# Session
session    include      system-auth
")
      }

      it {
        should contain_file('pam_password_auth').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/password-auth',
          'target' => 'password-auth-ac',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it_behaves_like "pam_d_login-el7"
      it_behaves_like "pam_d_sshd-el7"

      it { should_not contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so/) }
    end

    context 'with default params on Ubuntu 12.04 LTS' do
      let :facts do
        {
          :lsbdistid      => 'Ubuntu',
          :osfamily       => 'Debian',
          :lsbdistrelease => '12.04',
        }
      end

      it {
        should contain_package('libpam0g').with({
          'ensure' => 'installed',
        })
      }

      it {
        should contain_file('pam_common_auth').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_auth').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
auth  [success=1 default=ignore]  pam_unix.so nullok_secure
auth  requisite     pam_deny.so
auth  required      pam_permit.so
")
      }

      it {
        should contain_file('pam_common_account').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_account').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
account [success=1 new_authtok_reqd=done default=ignore]  pam_unix.so
account requisite     pam_deny.so
account required      pam_permit.so
")
      }

      it {
        should contain_file('pam_common_password').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_password').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
password  [success=1 default=ignore]  pam_unix.so obscure sha512
password  requisite     pam_deny.so
password  required      pam_permit.so
")
      }

      it { should contain_file('pam_common_noninteractive_session').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session-noninteractive',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_noninteractive_session').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
session [default=1]   pam_permit.so
session requisite     pam_deny.so
session required      pam_permit.so
session optional      pam_umask.so
session required      pam_unix.so
")
      }

      it { should contain_file('pam_common_session').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_session').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
session [default=1]   pam_permit.so
session requisite     pam_deny.so
session required      pam_permit.so
session optional      pam_umask.so
session required      pam_unix.so
")
      }

      it_behaves_like "pam_d_login-ubuntu12.04"
      it_behaves_like "pam_d_sshd-ubuntu12.04"

    end

    context 'with default params on osfamily Suse with lsbmajdistrelease 9' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '9',
        }
      end

      it {
        should contain_file('pam_other').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/other',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_other').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth  required  pam_warn.so
auth  required  pam_unix2.so

# Account
account  required  pam_warn.so
account  required  pam_unix2.so

# Password
password  required  pam_warn.so
password  required  pam_pwcheck.so use_cracklib

# Session
session  required  pam_warn.so
session  required  pam_unix2.so debug
")
      }
    end

    context 'with default params on osfamily Suse with lsbmajdistrelease 10' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '10',
        }
      end

      it {
        should contain_file('pam_common_auth').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it {  should contain_file('pam_common_auth').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
auth  required  pam_env.so
auth  required  pam_unix2.so
")
      }

      it {
        should contain_file('pam_common_account').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_account').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
account  required  pam_unix2.so
")
      }

      it {
        should contain_file('pam_common_password').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
         })
      }

      it { should contain_file('pam_common_password').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
password  required  pam_pwcheck.so nullok
password  required  pam_unix2.so nullok use_authtok
")
      }

      it {
        should contain_file('pam_common_session').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
         })
      }

      it { should contain_file('pam_common_session').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
session  required  pam_limits.so
session  required  pam_unix2.so
")
      }

      it_behaves_like "pam_d_login-suse10"
      it_behaves_like "pam_d_sshd-suse10"

    end

    context 'with default params on osfamily Suse with lsbmajdistrelease 11' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '11',
        }
      end

      it {
        should contain_file('pam_common_auth_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_auth_pc').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
auth  required  pam_env.so
auth  required  pam_unix2.so
")
      }

      it {
        should contain_file('pam_common_auth').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/common-auth',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it {
        should contain_file('pam_common_account_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_account_pc').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
account  required  pam_unix2.so
")
      }

      it {
        should contain_file('pam_common_account').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/common-account',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it {
        should contain_file('pam_common_password_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_password_pc').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
password  required  pam_pwcheck.so nullok cracklib
password  required  pam_unix2.so nullok use_authtok
")
      }

      it {
        should contain_file('pam_common_password').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/common-password',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it {
        should contain_file('pam_common_session_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_session_pc').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
session  required  pam_limits.so
session  required  pam_unix2.so
session  optional  pam_umask.so
")
      }

      it {
        should contain_file('pam_common_session').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/common-session',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it_behaves_like "pam_d_login-suse11"
      it_behaves_like "pam_d_sshd-suse11"
    end

    context 'with default params on osfamily Solaris with kernelrelease 5.9' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.9',
        }
      end

      it {
        should contain_file('pam_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.conf',
          'owner'   => 'root',
          'group'   => 'sys',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_conf').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
login   auth requisite          pam_authtok_get.so.1
login   auth required           pam_dhkeys.so.1
login   auth required           pam_unix_auth.so.1
login   auth required           pam_dial_auth.so.1
passwd  auth required           pam_passwd_auth.so.1
other   auth requisite          pam_authtok_get.so.1
other   auth required           pam_dhkeys.so.1
other   auth required           pam_unix_auth.so.1

# Account
cron    account required        pam_projects.so.1
cron    account required        pam_unix_account.so.1
other   account requisite       pam_roles.so.1
other   account required        pam_projects.so.1
other   account required        pam_unix_account.so.1

# Password
other   password required       pam_dhkeys.so.1
other   password requisite      pam_authtok_get.so.1
other   password requisite      pam_authtok_check.so.1
other   password required       pam_authtok_store.so.1

# Session
other   session required        pam_unix_session.so.1
")
      }
    end

    context 'with default params on osfamily Solaris with kernelrelease 5.10' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.10',
        }
      end

      it {
        should contain_file('pam_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.conf',
          'owner'   => 'root',
          'group'   => 'sys',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_conf').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
login   auth requisite          pam_authtok_get.so.1
login   auth required           pam_dhkeys.so.1
login   auth required           pam_unix_cred.so.1
login   auth required           pam_unix_auth.so.1
login   auth required           pam_dial_auth.so.1
passwd  auth required           pam_passwd_auth.so.1
other   auth requisite          pam_authtok_get.so.1
other   auth required           pam_dhkeys.so.1
other   auth required           pam_unix_cred.so.1
other   auth required           pam_unix_auth.so.1

# Account
other   account requisite       pam_roles.so.1
other   account required        pam_unix_account.so.1

# Password
other   password required       pam_dhkeys.so.1
other   password requisite      pam_authtok_get.so.1
other   password requisite      pam_authtok_check.so.1
other   password required       pam_authtok_store.so.1

# Session
other   session required        pam_unix_session.so.1
")
      }
    end

    context 'with default params on osfamily Solaris with kernelrelease 5.11' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.11',
        }
      end

      it {
        should contain_file('pam_other').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/other',
          'owner'   => 'root',
          'group'   => 'sys',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_other').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
# Auth
auth definitive         pam_user_policy.so.1
auth requisite          pam_authtok_get.so.1
auth required           pam_dhkeys.so.1
auth required           pam_unix_auth.so.1
auth required           pam_unix_cred.so.1

# Account
account requisite       pam_roles.so.1
account definitive      pam_user_policy.so.1
account required        pam_unix_account.so.1
account required        pam_tsol_account.so.1

# Password
password definitive     pam_user_policy.so.1
password include        pam_authtok_common
password required       pam_authtok_store.so.1

# Session
session definitive      pam_user_policy.so.1
session required        pam_unix_session.so.1
")
      }
    end

    context 'with ensure_vas=present and default vas_major_version (4) on osfamily RedHat with operatingsystemmajrelease 5' do
      let (:params) do
        {
          :ensure_vas => 'present',
        }
      end
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      it {
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/account[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/password[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/session[\s]+required[\s]+pam_vas3.so/) }
      it { should_not contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so.*store_creds/) }
    end

    context 'with ensure_vas=present and default vas_major_version (4) on osfamily RedHat with operatingsystemmajrelease 6' do
      let (:params) do
        {
          :ensure_vas => 'present',
        }
      end
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '6',
        }
      end

      it {
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/account[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/password[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/session[\s]+required[\s]+pam_vas3.so/) }
      it { should_not contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so.*store_creds/) }
    end

    context 'with ensure_vas=present and default vas_major_version (4) on osfamily RedHat with operatingsystemmajrelease 7' do
      let (:params) do
        {
          :ensure_vas => 'present',
        }
      end
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '7',
        }
      end

      it {
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/account[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/password[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/session[\s]+required[\s]+pam_vas3.so/) }
      it { should_not contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so.*store_creds/) }
    end

    context 'with ensure_vas=present and vas_major_version=3 on osfamily RedHat with operatingsystemmajrelease 5' do
      let (:params) do
        {
          :ensure_vas        => 'present',
          :vas_major_version => '3',
        }
      end
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      it {
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so.*store_creds/) }
      it { should contain_file('pam_system_auth_ac').with_content(/account[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/password[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/session[\s]+required[\s]+pam_vas3.so/) }
    end

    context 'with ensure_vas=present and vas_major_version=3 on osfamily RedHat with operatingsystemmajrelease 6' do
      let (:params) do
        {
          :ensure_vas        => 'present',
          :vas_major_version => '3',
        }
      end
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '6',
        }
      end

      it {
        should contain_file('pam_system_auth_ac').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/system-auth-ac',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so.*store_creds/) }
      it { should contain_file('pam_system_auth_ac').with_content(/account[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/password[\s]+sufficient[\s]+pam_vas3.so/) }
      it { should contain_file('pam_system_auth_ac').with_content(/session[\s]+required[\s]+pam_vas3.so/) }
    end

    context 'with ensure_vas=present on osfamily Suse with lsbmajdistrelease 10' do
      let(:params) { { :ensure_vas => 'present' } }
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '10',
        }
      end

      it {
        should contain_file('pam_common_auth').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_auth').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
auth  required    pam_env.so
auth  sufficient  pam_vas3.so show_lockout_msg get_nonvas_pass store_creds
auth  requisite   pam_vas3.so echo_return
auth  required    pam_unix2.so use_first_pass
")
      }

      it {
        should contain_file('pam_common_account').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_account').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
account  sufficient  pam_vas3.so
account  requisite   pam_vas3.so echo_return
account  required    pam_unix2.so
")
      }

      it {
        should contain_file('pam_common_password').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
         })
      }

      it { should contain_file('pam_common_password').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
password  sufficient  pam_vas3.so
password  requisite   pam_vas3.so echo_return
password  requisite   pam_pwcheck.so nullok
password  required    pam_unix2.so use_authtok nullok
")
      }

      it {
        should contain_file('pam_common_session').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
         })
      }

      it { should contain_file('pam_common_session').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
session  required   pam_limits.so
session  required   pam_vas3.so
session  requisite  pam_vas3.so echo_return
session  required   pam_unix2.so
")
      }

      it_behaves_like "pam_d_login-suse10"
      it_behaves_like "pam_d_sshd-suse10"

    end

    context 'with ensure_vas=present on osfamily Suse with lsbmajdistrelease 11' do
      let(:params) { { :ensure_vas => 'present' } }
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '11',
        }
      end

      it {
        should contain_file('pam_common_auth_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_auth_pc').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
auth  required    pam_env.so
auth  sufficient  pam_vas3.so create_homedir get_nonvas_pass
auth  requisite   pam_vas3.so echo_return
auth  required    pam_unix2.so use_first_pass
")
      }

      it {
        should contain_file('pam_common_auth').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/common-auth',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it {
        should contain_file('pam_common_account_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_account_pc').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
account  sufficient  pam_vas3.so
account  requisite   pam_vas3.so echo_return
account  required    pam_unix2.so
")
      }

      it {
        should contain_file('pam_common_account').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/common-account',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it {
        should contain_file('pam_common_password_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_password_pc').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
password  sufficient  pam_vas3.so
password  requisite   pam_vas3.so echo_return
password  requisite   pam_pwcheck.so nullok cracklib
password  required    pam_unix2.so use_authtok nullok
")
      }

      it {
        should contain_file('pam_common_password').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/common-password',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }

      it {
        should contain_file('pam_common_session_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_session_pc').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
session  required   pam_limits.so
session  required   pam_vas3.so create_homedir
session  requisite  pam_vas3.so echo_return
session  required   pam_unix2.so
session  optional   pam_umask.so
")
      }

      it {
        should contain_file('pam_common_session').with({
          'ensure' => 'symlink',
          'path'   => '/etc/pam.d/common-session',
          'owner'  => 'root',
          'group'  => 'root',
        })
      }
      it_behaves_like "pam_d_login-suse11"
      it_behaves_like "pam_d_sshd-suse11"

    end

    context 'with ensure_vas=present and vas_major_version=3 on Ubuntu 12.04 LTS' do
      let (:params) do
        {
          :ensure_vas        => 'present',
          :vas_major_version => '3',
        }
      end
      let :facts do
        {
          :osfamily       => 'Debian',
          :lsbdistid      => 'Ubuntu',
          :lsbdistrelease => '12.04',
        }
      end

      it { should contain_class('pam::accesslogin') }
      it { should contain_class('pam::limits') }

      it {
        should contain_package('libpam0g').with({
          'ensure' => 'installed',
        })
      }

      it_behaves_like "pam_d_login-ubuntu12.04"
      it_behaves_like "pam_d_sshd-ubuntu12.04"

      it {
        should contain_file('pam_common_auth').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_auth').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
auth        required    pam_env.so
auth        sufficient  pam_vas3.so show_lockout_msg get_nonvas_pass store_creds
auth        requisite   pam_vas3.so echo_return
auth        required    pam_unix.so use_first_pass
")
      }

      it {
        should contain_file('pam_common_account').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_account').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
account sufficient  pam_vas3.so
account requisite   pam_vas3.so echo_return
account [success=1 new_authtok_reqd=done default=ignore]  pam_unix.so
account requisite   pam_deny.so
account required    pam_permit.so
")
      }

      it {
        should contain_file('pam_common_password').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_password').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
password sufficient  pam_vas3.so
password  requisite pam_vas3.so echo_return
password  [success=1 default=ignore]  pam_unix.so obscure sha512
password  requisite pam_deny.so
password  required  pam_permit.so
")
      }

      it { should contain_file('pam_common_session').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_session').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
session  [default=1] pam_permit.so
session requisite pam_deny.so
session required  pam_permit.so
session optional  pam_umask.so
session required  pam_vas3.so create_homedir
session requisite pam_vas3.so echo_return
session required  pam_unix.so
")
      }

      it { should contain_file('pam_common_noninteractive_session').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session-noninteractive',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it { should contain_file('pam_common_noninteractive_session').with_content("# This file is being maintained by Puppet.
# DO NOT EDIT
session  [default=1] pam_permit.so
session requisite pam_deny.so
session required  pam_permit.so
session optional  pam_umask.so
session required  pam_vas3.so create_homedir
session requisite pam_vas3.so echo_return
session required  pam_unix.so
")
      }
    end

    context 'with ensure_vas=present and unsupported vas_major_version on osfamily RedHat with operatingsystemmajrelease 5' do
      let (:params) do
        {
          :ensure_vas        => 'present',
          :vas_major_version => '5',
        }
      end
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error,/Pam is only supported with vas_major_version 3 or 4/)
      end
    end

    context 'with ensure_vas=present and unsupported vas_major_version on osfamily RedHat with operatingsystemmajrelease 6' do
      let (:params) do
        {
          :ensure_vas        => 'present',
          :vas_major_version => '5',
        }
      end
      let :facts do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '6',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error,/Pam is only supported with vas_major_version 3 or 4/)
      end
    end

    context 'with ensure_vas=present and unsupported vas_major_version on osfamily RedHat with operatingsystemmajrelease 7' do
      let (:params) do
        {
          :ensure_vas        => 'present',
          :vas_major_version => '3',
        }
      end
      let :facts do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '7',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error,/Pam is only supported with vas_major_version 4 on EL7/)
      end
    end
  end
end
