require 'spec_helper'
describe 'pam::accesslogin' do
  let(:facts) { platforms['el5'][:facts_hash] }

  context 'with default values on supported platform' do
    it { should compile.with_all_deps }

    it { should contain_class('pam') }

    content = <<-END.gsub(/^\s+\|/, '')
      |# This file is being maintained by Puppet.
      |# DO NOT EDIT
      |#
      |
      |# allow only the groups listed
      |+ : root : ALL
      |
      |# default deny
      |- : ALL : ALL
    END

    it do
      should contain_file('access_conf').with({
        'ensure'  => 'file',
        'path'    => '/etc/security/access.conf',
        'content' => content,
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    end
  end

  context 'with access_conf_path set to a valid path' do
    let(:params) { {:access_conf_path => '/testing'} }
    it { should contain_file('access_conf').with_path('/testing') }
  end

  context 'with access_conf_owner set to a valid string' do
    let(:params) { {:access_conf_owner => 'tester'} }
    it { should contain_file('access_conf').with_owner('tester') }
  end

  context 'with access_conf_group set to a valid string' do
    let(:params) { {:access_conf_group => 'tester'} }
    it { should contain_file('access_conf').with_group('tester') }
  end

  context 'with access_conf_mode set to a valid string' do
    let(:params) { {:access_conf_mode => '0242'} }
    it { should contain_file('access_conf').with_mode('0242') }
  end

  context 'with access_conf_template set to a valid string' do
    let(:params) { {:access_conf_template => 'pam/unit_tests.erb'} }
    it { should contain_file('access_conf').with_content('dummy template for unit tests only') }
  end

  context 'with multiple users on supported platform expressed as an array' do
    let(:pre_condition) do
        'class {"pam": allowed_users => ["foo","bar"] }'
    end

    it { should contain_class('pam') }

    it {
      should contain_file('access_conf').with({
        'ensure'  => 'file',
        'path'    => '/etc/security/access.conf',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }

    content = <<-END.gsub(/^\s+\|/, '')
      |# This file is being maintained by Puppet.
      |# DO NOT EDIT
      |#
      |
      |# allow only the groups listed
      |+ : foo : ALL
      |+ : bar : ALL
      |
      |# default deny
      |- : ALL : ALL
    END

    it { should contain_file('access_conf').with_content(content) }
  end

  context 'with hash entry containing string values' do
    let(:pre_condition) do
        'class {"pam": allowed_users => {"username1" => "cron", "username2" => "tty0"} }'
    end
    it { should contain_file('access_conf').with_content(/^\+ : username1 : cron$/)}
    it { should contain_file('access_conf').with_content(/^\+ : username2 : tty0$/)}
  end

  context 'with hash entry containing array of values' do
    let(:pre_condition) do
        'class {"pam": allowed_users => {"username" => ["cron", "tty0"]} }'
    end
    it { should contain_file('access_conf').with_content(/^\+ : username : cron tty0$/)}
  end

  context 'with hash entry containing no value should default to "ALL"' do
    let(:pre_condition) do
        'class {"pam": allowed_users => {"username" => {} }}'
    end
    it { should contain_file('access_conf').with_content(/^\+ : username : ALL$/)}
  end

  context 'with hash entries containing string, array and empty hash' do
    let(:pre_condition) do
        'class {"pam": allowed_users => {"username" => "tty5", "username1" => ["cron", "tty0"], "username2" => "cron", "username3" => "tty0", "username4" => {}}}'
    end
    it { should contain_file('access_conf').with_content(/^\+ : username : tty5$/)}
    it { should contain_file('access_conf').with_content(/^\+ : username1 : cron tty0$/)}
    it { should contain_file('access_conf').with_content(/^\+ : username2 : cron$/)}
    it { should contain_file('access_conf').with_content(/^\+ : username3 : tty0$/)}
    it { should contain_file('access_conf').with_content(/^\+ : username4 : ALL$/)}
  end

  describe 'variable data type and content validations' do
    validations = {
      'Stdlib::Absolutepath' => {
        :name    => %w(access_conf_path),
        :valid   => ['/absolute/filepath', '/absolute/directory/'],
        :invalid => ['../invalid', %w(array), { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects a (match for|match for Stdlib::Absolutepath =|Stdlib::Absolutepath =) Variant\[Stdlib::Windowspath.*Stdlib::Unixpath', # Puppet (4.x|5.0 & 5.1|5.x)
      },
      'Stdlib::Filemode' => {
        :name    => %w(access_conf_mode),
        :valid   => %w(0644 0755 0640 0740),
        :invalid => [ 2770, '0844', '755', '00644', 'string', %w(array), { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects a match for Stdlib::Filemode',  # Puppet 4 & 5
      },
      'String' => {
        :name    => %w(access_conf_owner access_conf_group),
        :valid   => %w(string),
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a String', # Puppet 4 & 5
      },
      'String for access_conf_template' => {
        :name    => %w(access_conf_template),
        :valid   => %w(pam/unit_tests.erb),
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a String', # Puppet 4 & 5
      },
      'Variant[Array, Hash, String]' => {
        :name    => %w(allowed_users),
        :valid   => ['string', %w(array), { 'user' => 'origin' }],
        :invalid => [3, 2.42, false],
        :message => 'expects a value of type Array, Hash, or String', # Puppet 4 & 5
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
