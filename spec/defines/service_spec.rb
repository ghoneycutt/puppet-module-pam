require 'spec_helper'
describe 'pam::service', :type => :define do
  let(:facts) { platforms['el7'][:facts_hash] }
  let(:title) { 'test' }

  file_header = <<-END.gsub(/^\s+\|/, '')
    |# This file is being maintained by Puppet.
    |# DO NOT EDIT
  END

  context 'with defaults for all parameters' do
    it { should contain_class('pam') }

    it do
      should contain_file('pam.d-service-test').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => nil,
      })
    end
  end

  context 'with ensure set to a valid string present' do
    let(:params) { {:ensure => 'present' } }
    it { should contain_file('pam.d-service-test').with_ensure('file') }
  end

  context 'with ensure set to a valid string absent' do
    let(:params) { {:ensure => 'absent' } }
    it { should contain_file('pam.d-service-test').with_ensure('absent') }
  end

  context 'with pam_config_dir set to a valid path /test/pam.d' do
    let(:params) { {:pam_config_dir => '/test/pam.d' } }
    it { should contain_file('pam.d-service-test').with_path('/test/pam.d/test') }
  end

  context 'with content set to a valid string session required pam_permit.so' do
    let(:params) { {:content => 'session required pam_permit.so' } }
    it { should contain_file('pam.d-service-test').with_content('session required pam_permit.so') }
  end

  context 'with lines set to a valid array [ @include common-auth, session required pam_permit.so ]' do
    let(:params) { {:lines => [ '@include common-auth', 'session required pam_permit.so' ] } }
    it { should contain_file('pam.d-service-test').with_content(file_header + "@include common-auth\nsession required pam_permit.so\n") }
  end

  context 'with content and lines both set to valid values' do
    let(:params) do
      {
        :content => 'session required pam_permit.so',
        :lines => [ '@include common-auth', 'session required pam_permit.so' ],
      }
    end
    it 'should fail' do
      expect { should contain_class(subject) }.to raise_error(Puppet::Error, /pam::service expects one of the lines or contents parameters to be provided, but not both/)
    end
  end

  describe 'variable data type and content validations' do
    validations = {
      'Optional[Array]' => {
        :name    => %w(lines),
        :valid   => [%w(array)],
        :invalid => ['string', { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a value of type Undef or Array', # Puppet 4 & 5
      },
      'Optional[String]' => {
        :name    => %w(content),
        :valid   => %w('string'),
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a value of type Undef or String', # Puppet 4 & 5
      },
      'Optional[Enum[]] for ensure' => {
        :name    => %w(ensure),
        :valid   => %w(absent present),
        :invalid => ['string', %w(array), { 'ha' => 'sh' }, false],
        :message => 'expects a(n undef value or a)? match for Enum', # Puppet (4) & 5
      },
      'Stdlib::Absolutepath' => {
        :name    => %w(pam_config_dir),
        :valid   => ['/absolute/filepath', '/absolute/directory/'],
        :invalid => ['../invalid', %w(array), { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects a (match for|match for Stdlib::Absolutepath =|Stdlib::Absolutepath =) Variant\[Stdlib::Windowspath.*Stdlib::Unixpath', # Puppet (4.x|5.0 & 5.1|5.x)
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
