require 'spec_helper'

describe 'pam::limits::fragment' do
  let(:facts) { platforms['el7'][:facts_hash] }
  let(:title) { '80-nproc' }

  mandatory_params = {
    :list => [ 'test1', 'test2' ],
  }

  file_header = <<-END.gsub(/^\s+\|/, '')
    |# This file is being maintained by Puppet.
    |# DO NOT EDIT
  END

  context 'with defaults for all parameters' do
    it 'should fail' do
      expect { should contain_class(subject) }.to raise_error(Puppet::Error, /pam::limits::fragment must specify source or list/)
    end
  end

  context 'with mandatory parameters set to valid values' do
    let(:params) { mandatory_params }
    it { should compile.with_all_deps }
    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }
    it do
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'ensure'  => 'file',
        'source'  => nil,
        'content' => file_header + "test1\ntest2\n",
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]' ],
      })
    end
  end

  context 'with source set to a valid string puppet:///modules/pam/example.conf' do
    let(:params) { { :source => 'puppet:///modules/pam/example.conf' } }
    it { should contain_file('/etc/security/limits.d/80-nproc.conf').with_source('puppet:///modules/pam/example.conf') }
  end

  context 'with list set to a valid array [test1, test2]' do
    let(:params) { { :list => [ 'test1', 'test2' ] } }
    it { should contain_file('/etc/security/limits.d/80-nproc.conf').with_content(file_header + "test1\ntest2\n") }
  end

  context 'with source and list both set to valid values' do
    let(:params) do
      {
        :source => 'puppet:///modules/pam/example.conf',
        :list => [ 'test1', 'test2' ],
      }
    end
    it { should contain_file('/etc/security/limits.d/80-nproc.conf').with_content(file_header + "test1\ntest2\n") }
  end

  %w(absent present file).each do |value|
    context "with ensure set to a valid string #{value}" do
      let(:params) { mandatory_params.merge({ :ensure => value }) }
      it { should contain_file('/etc/security/limits.d/80-nproc.conf').with_ensure(value) }
    end
  end

  context 'on unsupported platform Suse 10.x' do
    let(:facts) { platforms['suse10'][:facts_hash] }
    it 'should fail' do
      expect { should contain_class(subject) }.to raise_error(Puppet::Error, /You can not use pam::limits::fragment together with Suse 10.x releases/)
    end
  end
end
