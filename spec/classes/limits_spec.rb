require 'spec_helper'
describe 'pam::limits' do
  describe 'limits.conf' do
  	context 'ensure file exists' do
  		let(:facts) do
  			{
  				:osfamily          => 'RedHat',
  				:lsbmajdistrelease => '5',
  			}
  		end
  		it {
  			should include_class('pam')
  			should contain_file('limits_conf').with({
  				'ensure' => 'file',
  				'path'   => '/etc/security/limits.conf',
  				'owner'  => 'root',
  				'group'  => 'root',
  				'mode'   => '0644',
  				})
  		}
  	end
  end
end
