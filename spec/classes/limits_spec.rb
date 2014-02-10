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
    context 'with config_file specified as an invalid path' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      let(:params) do
        { :config_file => 'custom/security/limits.conf' }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/not an absolute path/)
      end
    end
  end
  describe 'limits.d' do
    context 'ensure directory exists with default values for params on a supported platform' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      it { should contain_class('pam') }

      it {
        should contain_file('limits_d').with({
          'ensure'  => 'directory',
          'path'    => '/etc/security/limits.d',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0755',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }
    end

    context 'ensure directory exists with custom values for params on a supported platform' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      let(:params) do
        { :limits_d_dir => '/custom/security/limits.d' }
      end

      it { should contain_class('pam') }
      it { should contain_class('common') }

      it {
        should contain_file('limits_d').with({
          'ensure'  => 'directory',
          'path'    => '/custom/security/limits.d',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0755',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }
    end

    context 'with limits_d_dir specified as an invalid path' do
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      let(:params) do
        { :limits_d_dir => 'custom/security/limits.d' }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/not an absolute path/)
      end
    end
  end
end
