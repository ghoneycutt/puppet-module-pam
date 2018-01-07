require 'spec_helper'

describe 'pam::limits::fragment' do
  let(:title) { '80-nproc' }
  let(:facts) { platforms['el5'][:facts_hash] }

  context 'create file from source when source is specified' do
    let(:params) { { :source => 'puppet:///modules/pam/example.conf' } }

    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'source'  => 'puppet:///modules/pam/example.conf',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }
  end

  context 'create file from template when list is specified' do
    let(:params) {
      { :list => ['* soft nproc 1024',
                  'root soft nproc unlimited',
                  '* soft cpu 720'] }
    }

    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }
    it { should contain_file('/etc/security/limits.d/80-nproc.conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
* soft nproc 1024
root soft nproc unlimited
* soft cpu 720
})
    }
  end

  context 'create file from template when list and source is specified' do
    let(:params) {
      { :list => ['* soft nproc 1024',
                  'root soft nproc unlimited',
                  '* soft cpu 720'],
        :source => 'puppet:///modules/pam/example.conf',
      }
    }

    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }
    it { should contain_file('/etc/security/limits.d/80-nproc.conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
* soft nproc 1024
root soft nproc unlimited
* soft cpu 720
})
    }
  end

  context 'with ensure set to present' do
    let(:params) {
      { :ensure => 'present',
        :list   => ['* soft nproc 1024'],
      }
    }

    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }
  end

  context 'with ensure set to absent' do
    let(:params) {
      { :ensure => 'absent' }
    }
    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'ensure'  => 'absent',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }
  end

  context 'with ensure set to invalid value' do
    let(:params) {
      { :ensure => 'installed',
        :list   => ['* soft nproc 1024'] }
    }

    it 'should fail' do
      expect {
        should contain_class('pam::limits')
      }.to raise_error(Puppet::Error,/match for Enum\[\'absent\', \'file\', \'present\'\]/)
    end
  end

  context 'if neither source or list is specified' do
    it 'should fail' do
      expect {
        should contain_class('pam::limits')
      }.to raise_error(Puppet::Error,/pam::limits::fragment must specify source or list./)
    end
  end

  context 'on unsupported platform Suse 10.x' do
    let(:facts) { platforms['suse10'][:facts_hash] }
    it 'should fail' do
      expect {
        should contain_class('pam::limits::fragment')
      }.to raise_error(Puppet::Error,/You can not use pam::limits::fragment together with Suse 10.x releases/)
    end
  end

  describe 'variable data type and content validations' do
    validations = {
      'string (optional) specific for source' => {
        :name    => %w(source),
        :valid   => %w(puppet:///modules/pam/example.conf),
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, true],
        :message => 'expects a value of type Undef or String',  # Puppet 4 & 5
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
