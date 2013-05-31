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
      it do
        should include_class('pam')
        should contain_file('access_conf').with({
          'ensure' => 'file',
          'path'   => '/etc/security/access.conf',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          })
        should contain_file('access_conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#

# allow only the groups listed
+ : root : ALL

# default deny
- : ALL : ALL
})
      end
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
      it do
        should include_class('pam')
        should contain_file('access_conf').with({
          'ensure' => 'file',
          'path'   => '/etc/security/access.conf',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          })
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
      end
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

      it do
        should include_class('pam')
        should contain_file('access_conf').with({
          'ensure' => 'file',
          'path'   => '/custom/security/access.conf',
          'owner'  => 'guido',
          'group'  => 'guido',
          'mode'   => '0777',
          })
      end
    end
  end
end
