require 'spec_helper'
describe 'pam::limits' do
  describe 'limits.conf' do
    context 'ensure file exists with default values for params on a supported platform' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
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
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
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

    context 'with config_file_source specified as an valid string' do
      let(:facts) do
        {
          :osfamily                  => 'RedHat',
          :lsbmajdistrelease         => '6',
          :operatingsystemmajrelease => '6',
        }
      end

      let(:params) do
        {
          :config_file_source => 'puppet:///modules/pam/own.limits.conf',
        }
      end

      it {
        should contain_file('limits_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/limits.conf',
          'source'  => 'puppet:///modules/pam/own.limits.conf',
          'content' => nil,
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0640',
          'require' => 'Package[pam]',
        })
      }

    end

    context 'with config_file_lines specified as an valid array' do
      let(:facts) do
        {
          :osfamily                  => 'RedHat',
          :lsbmajdistrelease         => '6',
          :operatingsystemmajrelease => '6',
        }
      end

      let(:params) do
        {
          :config_file_lines => [ '* soft nofile 2048', '* hard nofile 8192', ]
        }
      end

      it {
        should contain_file('limits_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/limits.conf',
          'source'  => nil,
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0640',
          'require' => 'Package[pam]',
        })
      }

      it { should contain_file('limits_conf').with_content(/^\* soft nofile 2048$/) }
      it { should contain_file('limits_conf').with_content(/^\* hard nofile 8192$/) }

    end

    context 'with config_file_lines specified as an invalid string' do
      let(:facts) do
        {
          :osfamily                  => 'RedHat',
          :lsbmajdistrelease         => '6',
          :operatingsystemmajrelease => '6',
        }
      end

      let(:params) do
        {
          :config_file_lines => '* soft nofile 2048',

        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/is not an Array.  It looks to be a String/)
      end

    end

    context 'with config_file_source specified as an valid string and config_file_lines specified as an valid array' do
      let(:facts) do
        {
          :osfamily                  => 'RedHat',
          :lsbmajdistrelease         => '6',
          :operatingsystemmajrelease => '6',
        }
      end

      let(:params) do
        {
          :config_file_source => 'puppet:///modules/pam/own.limits.conf',
          :config_file_lines => [ '* soft nofile 2048', '* hard nofile 8192', ]
        }
      end

      it {
        should contain_file('limits_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/limits.conf',
          'source'  => nil,
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0640',
          'require' => 'Package[pam]',
        })
      }

      it { should contain_file('limits_conf').with_content(/^\* soft nofile 2048$/) }
      it { should contain_file('limits_conf').with_content(/^\* hard nofile 8192$/) }

    end

    context 'with config_file specified as an invalid path' do
      let(:params) { { :config_file => 'custom/security/limits.conf' } }
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
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
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
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
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
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
          'purge'   => 'false',
          'recurse' => 'false',
          'require' => [ 'Package[pam]', 'Package[util-linux]', 'Common::Mkdir_p[/etc/security/limits.d]' ],
        })
      }
    end

    context 'ensure directory exists with custom values for params on a supported platform' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
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
          'purge'   => 'false',
          'recurse' => 'false',
          'require' => [ 'Package[pam]', 'Package[util-linux]', 'Common::Mkdir_p[/custom/security/limits.d]' ],
        })
      }
    end

    [true,'true'].each do |value|
      context "with purge_limits_d_dir set to #{value}" do
        let(:params) { { :purge_limits_d_dir => value } }
        let(:facts) do
          {
            :osfamily                  => 'RedHat',
            :operatingsystemmajrelease => '5',
          }
        end

        it {
          should contain_file('limits_d').with({
            'ensure'  => 'directory',
            'path'    => '/etc/security/limits.d',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0750',
            'purge'   => 'true',
            'recurse' => 'true',
            'require' => [ 'Package[pam]', 'Package[util-linux]', 'Common::Mkdir_p[/etc/security/limits.d]' ],
          })
        }
      end
    end

    [false,'false'].each do |value|
      context "with purge_limits_d_dir set to #{value}" do
        let(:params) { { :purge_limits_d_dir => value } }
        let(:facts) do
          {
            :osfamily                  => 'RedHat',
            :operatingsystemmajrelease => '5',
          }
        end

        it {
          should contain_file('limits_d').with({
            'ensure'  => 'directory',
            'path'    => '/etc/security/limits.d',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0750',
            'purge'   => 'false',
            'recurse' => 'false',
            'require' => [ 'Package[pam]', 'Package[util-linux]', 'Common::Mkdir_p[/etc/security/limits.d]' ],
          })
        }
      end
    end

    context 'with limits_d_dir specified as an invalid path' do
      let(:params) { { :limits_d_dir => 'custom/security/limits.d' } }
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
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
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/pam::limits::limits_d_dir_mode is <777> and must be a valid four digit mode in octal notation./)
      end
    end

    context 'with purge_limits_d_dir set to an invalid value' do
      let(:params) { { :purge_limits_d_dir => 'invalid' } }
      let(:facts) do
        {
          :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '5',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/str2bool/)
      end
    end

    context 'without fragments support on Suse 10' do
      let(:facts) do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '10',
        }
      end

      it { should contain_class('pam') }
      it { should_not contain_common__mkdir_p('/etc/security/limits.d') }
      it { should_not contain_file('limits_d') }
    end

  end
end
