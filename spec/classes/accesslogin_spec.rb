require 'spec_helper'

describe 'pam::accesslogin' do

  let :facts do
    {
      :osfamily          => 'redhat',
      :lsbmajdistrelease => '5',
    }
  end
  it do
    should include_class('pam')
  end

  describe 'access conf file' do

    context 'with class defaults' do

      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end

      it do
        should contain_file('access_conf').with({
          'ensure' => 'file',
          'path'   => '/etc/security/access.conf',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })

      end
      it 'should contain File[access_conf] with correct content' do
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

    context 'with allowed set' do

      let :facts do
        {
          :osfamily          => 'redhat',
          :lsbmajdistrelease => '5',
        }
      end

      let (:params) { {:allowed => ['foo','bar']} }

      it 'should contain File[access_conf] with correct content' do
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
  end
end
