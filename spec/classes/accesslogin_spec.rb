require 'spec_helper'
describe 'pam::accesslogin' do
  describe 'access.conf' do
    context 'with default values on supported platform' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      it { should contain_class('pam') }

      it {
        should contain_file('access_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/access.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }

      it {
        should contain_file('access_conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#

# allow only the groups listed
+ : root : ALL

# default deny
- : ALL : ALL
})
      }
    end

    context 'with multiple users on supported platform' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => ["foo","bar"] }'
      end

      it { should contain_class('pam') }

      it {
        should contain_file('access_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/access.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }

      it {
        should contain_file('access_conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#

# allow only the groups listed
+ : foo : ALL
+ : bar : ALL

# default deny
- : ALL : ALL
})
      }
    end

    context 'with allowed users set to hash with a string value' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username1" => "cron", "username2" => "tty0"} }'
      end
      it { should contain_file('access_conf').with_content(/^\+ : username1 : cron$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username2 : tty0$/)}
    end

    context 'with allowed users set to hash with a hash of arrays' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username" => ["cron", "tty0"]} }'
      end
      it { should contain_file('access_conf').with_content(/^\+ : username : cron tty0$/)}
    end

    context 'with allowed users set as a string' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => "username"}'
      end
      it { should contain_file('access_conf').with_content(/^\+ : username : ALL$/)}
    end

    context 'with custom values on supported platform' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      let(:params) do
        {
          :access_conf_path     => '/custom/security/access.conf',
          :access_conf_owner    => 'guido',
          :access_conf_group    => 'guido',
          :access_conf_mode     => '0777',
        }
      end

      it { should contain_class('pam') }

      it {
        should contain_file('access_conf').with({
          'ensure'  => 'file',
          'path'    => '/custom/security/access.conf',
          'owner'   => 'guido',
          'group'   => 'guido',
          'mode'    => '0777',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }
    end
  end
end
