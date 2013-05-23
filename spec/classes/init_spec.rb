require 'spec_helper'

describe 'pam' do

	let :facts do 
		{ 
			:osfamily => 'redhat', 
			:lsbmajdistrelease => '5',
		}
	end

	describe 'has correct packages installed' do

		it do
			should contain_package('pam_package').with({
				'ensure' => 'installed',
				'name'   => ['pam', 'util-linux'],
			})
		end

        context 'with package_name => foo' do
			let(:params) { {:package_name => 'foo'} }
			it do
    	    	should contain_package('pam_package').with({
        	    	'ensure' => 'installed',
					'name'   => 'foo',
				})
			end
		end
	end

	describe 'pam_system_auth_ac' do

		it do

			should contain_file('pam_system_auth_ac').with({ 
				'ensure'  => 'file',
				'path'    => '/etc/pam.d/system-auth-ac',
				'owner'   => 'root', 
				'group'   => 'root', 
				'mode'    => '0644',
			})

		end

	end

	it do
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

