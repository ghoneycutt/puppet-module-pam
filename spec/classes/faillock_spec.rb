require 'spec_helper'
require 'spec_platforms'

describe 'pam::faillock' do
  on_supported_os.each do |os, os_facts|
    # this function call mimic hiera data, it is sourced in from spec/spec_platforms.rb
    package_name = package_name(os)

    context "on #{os}" do
      let(:facts) { os_facts }
      let(:content) do
        <<-END.gsub(%r{^\s+\|}, '')
          |# This file is being maintained by Puppet.
          |# DO NOT EDIT
          |#
          |dir = /var/run/faillock
          |deny = 3
          |fail_interval = 900
          |unlock_time = 600
          |root_unlock_time = 600
        END
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('pam') }

      it do
        is_expected.to contain_file('faillock.conf').with(
          'ensure'  => 'file',
          'path'    => '/etc/security/faillock.conf',
          'source'  => nil,
          'content' => content,
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        )
      end

      package_name.sort.each do |pkg|
        it { is_expected.to contain_file('faillock.conf').that_requires("Package[#{pkg}]") }
      end

      context 'with config_file set to a valid path' do
        let(:params) { { config_file: '/testing' } }

        it { is_expected.to contain_file('faillock.conf').with_path('/testing') }
      end

      context 'with config_file_source set to a valid string' do
        let(:params) { { config_file_source: 'puppet:///pam/unit_tests.erb' } }

        it { is_expected.to contain_file('faillock.conf').with_source('puppet:///pam/unit_tests.erb') }
        it { is_expected.to contain_file('faillock.conf').with_content(nil) }
      end

      context 'with config_file_mode set to a valid string' do
        let(:params) { { config_file_mode: '0242' } }

        it { is_expected.to contain_file('faillock.conf').with_mode('0242') }
      end

      context 'when config options are non-default' do
        let(:params) do
          {
            dir: '/foo',
            audit_enabled: true,
            silent: true,
            no_log_info: true,
            local_users_only: true,
            deny: 1,
            fail_interval: 2,
            unlock_time: 3,
            even_deny_root: true,
            root_unlock_time: 4,
            admin_group: 'admins',
          }
        end
        let(:content) do
          <<-END.gsub(%r{^\s+\|}, '')
            |# This file is being maintained by Puppet.
            |# DO NOT EDIT
            |#
            |dir = /foo
            |audit
            |silent
            |no_log_info
            |local_users_only
            |deny = 1
            |fail_interval = 2
            |unlock_time = 3
            |even_deny_root
            |root_unlock_time = 4
            |admin_group = admins
          END
        end

        it { is_expected.to contain_file('faillock.conf').with_content(content) }
      end
    end
  end
end
