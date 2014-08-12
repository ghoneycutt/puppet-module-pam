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
          'mode'    => '0640',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }
    end

    context 'ensure file exists with custom values for params on a supported platform' do
      let(:params) do
        {
          :config_file      => '/custom/security/limits.conf',
          :config_file_mode => '0600',
        }
      end
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
          'path'    => '/custom/security/limits.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0600',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }
    end

    context 'with config_file specified as an invalid path' do
      let(:params) { { :config_file => 'custom/security/limits.conf' } }
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/not an absolute path/)
      end
    end

    context 'with config_file_mode specified as an invalid mode' do
      let(:params) { { :config_file_mode => '666' } }
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/pam::limits::config_file_mode is <666> and must be a valid four digit mode in octal notation./)
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

      it { should contain_common__mkdir_p('/etc/security/limits.d') }

      it {
        should contain_file('limits_d').with({
          'ensure'  => 'directory',
          'path'    => '/etc/security/limits.d',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0750',
          'require' => [ 'Package[pam]', 'Package[util-linux]', 'Common::Mkdir_p[/etc/security/limits.d]' ],
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
        {
          :limits_d_dir     => '/custom/security/limits.d',
          :limits_d_dir_mode => '0700',
        }
      end

      it { should contain_class('pam') }

      it { should contain_common__mkdir_p('/custom/security/limits.d') }

      it {
        should contain_file('limits_d').with({
          'ensure'  => 'directory',
          'path'    => '/custom/security/limits.d',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0700',
          'require' => [ 'Package[pam]', 'Package[util-linux]', 'Common::Mkdir_p[/custom/security/limits.d]' ],
        })
      }
    end

    context 'with limits_d_dir specified as an invalid path' do
      let(:params) { { :limits_d_dir => 'custom/security/limits.d' } }
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/not an absolute path/)
      end
    end

    context 'with limits_d_dir_mode specified as an invalid mode' do
      let(:params) { { :limits_d_dir_mode => '777' } }
      let(:facts) do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/pam::limits::limits_d_dir_mode is <777> and must be a valid four digit mode in octal notation./)
      end
    end
  end
end
