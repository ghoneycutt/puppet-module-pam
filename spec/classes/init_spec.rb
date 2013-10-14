require 'spec_helper'
describe 'pam' do

  describe 'packages' do

    context 'with class defaults on osfamily redhat with lsbmajdistrelease 5' do
      let :facts do
        {
          :osfamily          => 'RedHat',
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

    context 'with class defaults on osfamily redhat with lsbmajdistrelease 6' do
      let :facts do
        {
          :osfamily          => 'RedHat',
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

    context 'with class defaults on osfamily suse with lsbmajdistrelease 11' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '11',
        }
      end

      it do
        should contain_package('pam_package').with({
          'ensure' => 'installed',
          'name'   => 'pam',
        })
      end
    end

    context 'with class defaults on osfamily suse with lsbmajdistrelease 10' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '10',
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
          :osfamily          => 'RedHat',
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
  end

  describe 'config files' do

    context 'defaults on osfamily redhat with lsbmajdistrelease 5' do
      let :facts do
        {
          :osfamily          => 'RedHat',
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

      should contain_file('pam_system_auth').with({
        'ensure' => 'symlink',
        'path'   => '/etc/pam.d/system-auth',
        'owner'  => 'root',
        'group'  => 'root',
      })

      should contain_file('pam_d_login').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/login',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })

      should contain_file('pam_d_sshd').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/sshd',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      end
    end

    context 'defaults on osfamily redhat with lsbmajdistrelease 6' do
      let :facts do
        {
          :osfamily          => 'RedHat',
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

      should contain_file('pam_system_auth').with({
        'ensure' => 'symlink',
        'path'   => '/etc/pam.d/system-auth',
        'owner'  => 'root',
        'group'  => 'root',
      })

      should contain_file('pam_d_login').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/login',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })

      should contain_file('pam_d_sshd').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/sshd',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      end
    end

    context 'with class defaults on Ubuntu 12.04 LTS' do
      let :facts do
        {
          :operatingsystem   => 'Ubuntu',
          :osfamily          => 'Debian',
          :lsbmajdistrelease => '12',
        }
      end

      it do
        should contain_package('pam_package').with({
          'ensure' => 'installed',
          'name'   => 'libpam0g',
        })
      end

      it do
        should contain_file('pam_common_auth').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_account').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_password').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_session').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_d_login').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/login',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })

      should contain_file('pam_d_sshd').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/sshd',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      end
    end

    context 'defaults on osfamily suse with lsbmajdistrelease 10' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '10',
        }
      end

      it do
        should contain_file('pam_common_auth').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_account').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_password').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_session').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_d_login').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/login',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })

      should contain_file('pam_d_sshd').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/sshd',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      end
    end

    context 'defaults on osfamily suse with lsbmajdistrelease 11' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '11',
        }
      end

      it do
        should contain_file('pam_common_auth_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-auth-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_auth').with({
        'ensure' => 'symlink',
        'path'   => '/etc/pam.d/common-auth',
        'owner'  => 'root',
        'group'  => 'root',
      })

      should contain_file('pam_common_account_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-account-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_account').with({
        'ensure' => 'symlink',
        'path'   => '/etc/pam.d/common-account',
        'owner'  => 'root',
        'group'  => 'root',
      })

      should contain_file('pam_common_password_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-password-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_password').with({
        'ensure' => 'symlink',
        'path'   => '/etc/pam.d/common-password',
        'owner'  => 'root',
        'group'  => 'root',
      })

      should contain_file('pam_common_session_pc').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/common-session-pc',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })

      should contain_file('pam_common_session').with({
        'ensure' => 'symlink',
        'path'   => '/etc/pam.d/common-session',
        'owner'  => 'root',
        'group'  => 'root',
      })

      should contain_file('pam_d_login').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/login',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })

      should contain_file('pam_d_sshd').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/sshd',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      end
    end

    context 'defaults on osfamily solaris with kernelrelease 5.10' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.10',
        }
      end

      it do
        should contain_file('pam_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.conf',
          'owner'   => 'root',
          'group'   => 'sys',
          'mode'    => '0644',
        })
      end
    end
    context 'defaults on osfamily solaris with kernelrelease 5.11' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.11',
        }
      end

      it do
        should contain_file('pam_other').with({
          'ensure'  => 'file',
          'path'    => '/etc/pam.d/other',
          'owner'   => 'root',
          'group'   => 'sys',
          'mode'    => '0644',
        })
        should contain_file('pam_other').with_content("# This file is being maintained by Puppet.
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
      end
    end
  end
end
