require 'spec_helper'
describe 'pam::limits' do
  describe 'limits.conf' do
    context 'ensure file exists with default values for params on a supported platform' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      it { should contain_class('pam') }

      it {
        should contain_file('limits_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/limits.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }
    end

    context 'ensure file exists with custom values for params on a supported platform' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      let(:params) do
        { :config_file  => '/custom/security/limits.conf' }
      end

      it { should contain_class('pam') }

      it {
        should contain_file('limits_conf').with({
          'ensure'  => 'file',
          'path'    => '/custom/security/limits.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }
    end
  end
end
