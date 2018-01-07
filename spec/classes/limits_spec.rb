require 'spec_helper'
describe 'pam::limits' do
  let(:facts) { platforms['el5'][:facts_hash] }

  describe 'limits.conf' do
    context 'ensure file exists with default values for params on a supported platform' do
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
      let(:params) { { :config_file_source => 'puppet:///modules/pam/own.limits.conf' } }

      it {
        should contain_file('limits_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/limits.conf',
          'source'  => 'puppet:///modules/pam/own.limits.conf',
          'content' => nil,
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0640',
          'require' => ['Package[pam]','Package[util-linux]'],
        })
      }

    end

    context 'with config_file_lines specified as an valid array' do
      let(:params) { { :config_file_lines => [ '* soft nofile 2048', '* hard nofile 8192' ] } }

      it {
        should contain_file('limits_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/limits.conf',
          'source'  => nil,
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0640',
          'require' => ['Package[pam]','Package[util-linux]'],
        })
      }

      it { should contain_file('limits_conf').with_content(/^\* soft nofile 2048$/) }
      it { should contain_file('limits_conf').with_content(/^\* hard nofile 8192$/) }

    end

    context 'with config_file_lines specified as an invalid string' do
      let(:params) { { :config_file_lines => '* soft nofile 2048' } }

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/Array/)
      end

    end

    context 'with config_file_source specified as an valid string and config_file_lines specified as an valid array' do
      let(:params) do
        {
          :config_file_source => 'puppet:///modules/pam/own.limits.conf',
          :config_file_lines  => [ '* soft nofile 2048', '* hard nofile 8192', ]
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
          'require' => ['Package[pam]','Package[util-linux]'],
        })
      }

      it { should contain_file('limits_conf').with_content(/^\* soft nofile 2048$/) }
      it { should contain_file('limits_conf').with_content(/^\* hard nofile 8192$/) }

    end

    context 'with config_file specified as an invalid path' do
      let(:params) { { :config_file => 'custom/security/limits.conf' } }

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/Evaluation Error: Error while evaluating a Resource Statement/)
      end
    end
  end

  describe 'limits.d' do
    context 'ensure directory exists with default values for params on a supported platform' do
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

    [true,false].each do |value|
      context "with purge_limits_d_dir set to #{value}" do
        let(:params) { { :purge_limits_d_dir => value } }

        it {
          should contain_file('limits_d').with({
            'ensure'  => 'directory',
            'path'    => '/etc/security/limits.d',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0750',
            'purge'   => value,
            'recurse' => value,
            'require' => [ 'Package[pam]', 'Package[util-linux]', 'Common::Mkdir_p[/etc/security/limits.d]' ],
          })
        }
      end
    end

    context 'with limits_d_dir specified as an invalid path' do
      let(:params) { { :limits_d_dir => 'custom/security/limits.d' } }
      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/Evaluation Error: Error while evaluating a Resource Statement/)
      end
    end

    context 'with purge_limits_d_dir set to an invalid value' do
      let(:params) { { :purge_limits_d_dir => 'invalid' } }

      it 'should fail' do
        expect {
          should contain_class('pam::limits')
        }.to raise_error(Puppet::Error,/expects a Boolean value/)
      end
    end

    context 'without fragments support on Suse 10' do
      let(:facts) { platforms['suse10'][:facts_hash] }

      it { should contain_class('pam') }
      it { should_not contain_common__mkdir_p('/etc/security/limits.d') }
      it { should_not contain_file('limits_d') }
    end
  end

  describe 'variable data type and content validations' do
    validations = {
      'Stdlib::Filemode' => {
        :name    => %w(config_file_mode limits_d_dir_mode),
        :valid   => %w(0644 0755 0640 0740),
        :invalid => [ 2770, '0844', '755', '00644', 'string', %w(array), { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects a match for Stdlib::Filemode',  # Puppet 4 & 5
      },
    }

    validations.sort.each do |type, var|
      mandatory_params = {} if mandatory_params.nil?
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:facts) { [mandatory_facts, var[:facts]].reduce(:merge) } if ! var[:facts].nil?
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => valid, }].reduce(:merge) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => invalid, }].reduce(:merge) }
            it 'should fail' do
              expect { should contain_class(subject) }.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
