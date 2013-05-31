require 'spec_helper'
describe 'pam::accesslogin' do
	describe 'access.conf' do
		context 'with default values' do
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
		context 'with multiple users' do
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
	end
end
