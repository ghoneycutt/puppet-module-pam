require 'spec_helper'
require 'spec_platforms'

describe 'pam::limits::fragment', type: :define do
  on_supported_os.each do |os, os_facts|
    # this function call mimic hiera data, it is sourced in from spec/spec_platforms.rb
    package_name = package_name(os)

    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { '80-nproc' }

      mandatory_params = {
        list: [ 'test1', 'test2' ],
      }

      file_header = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
      END

      context 'with defaults for all parameters' do
        it 'fails' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{pam::limits::fragment must specify source or list})
        end
      end

      context 'with mandatory parameters set to valid values' do
        let(:params) { mandatory_params }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('pam') }
        it { is_expected.to contain_class('pam::limits') }
        it do
          is_expected.to contain_file('/etc/security/limits.d/80-nproc.conf').with(
            'ensure' => 'file',
            'source'  => nil,
            'content' => file_header + "test1\ntest2\n",
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
          )
        end
        package_name.each do |pkg|
          it { is_expected.to contain_file('/etc/security/limits.d/80-nproc.conf').that_requires("Package[#{pkg}]") }
        end
      end

      context 'with source set to a valid string puppet:///modules/pam/example.conf' do
        let(:params) { { source: 'puppet:///modules/pam/example.conf' } }

        it { is_expected.to contain_file('/etc/security/limits.d/80-nproc.conf').with_source('puppet:///modules/pam/example.conf') }
      end

      context 'with list set to a valid array [test1, test2]' do
        let(:params) { { list: [ 'test1', 'test2' ] } }

        it { is_expected.to contain_file('/etc/security/limits.d/80-nproc.conf').with_content(file_header + "test1\ntest2\n") }
      end

      context 'with source and list both set to valid values' do
        let(:params) do
          {
            source: 'puppet:///modules/pam/example.conf',
            list: [ 'test1', 'test2' ],
          }
        end

        it { is_expected.to contain_file('/etc/security/limits.d/80-nproc.conf').with_content(file_header + "test1\ntest2\n") }
      end

      ['absent', 'present', 'file'].each do |value|
        context "with ensure set to a valid string #{value}" do
          let(:params) { mandatory_params.merge({ ensure: value }) }

          it { is_expected.to contain_file('/etc/security/limits.d/80-nproc.conf').with_ensure(value) }
        end
      end
    end
  end
end
