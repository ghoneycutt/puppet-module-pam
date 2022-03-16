require 'spec_helper'
require 'spec_platforms'

describe 'pam::accesslogin' do
  on_supported_os.each do |os, os_facts|
    # this function call mimic hiera data, it is sourced in from spec/spec_platforms.rb
    package_name = package_name(os)

    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('pam') }

      content_default = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |#
        |
        |# allow only the groups listed
        |+:root:ALL
        |
        |# default deny
        |-:ALL:ALL
      END

      it do
        is_expected.to contain_file('access_conf').with(
          'ensure'  => 'file',
          'path'    => '/etc/security/access.conf',
          'content' => content_default,
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        )
      end

      package_name.each do |package|
        it { is_expected.to contain_file('access_conf').that_requires("Package[#{package}]") }
      end

      context 'with access_conf_path set to a valid path' do
        let(:params) { { access_conf_path: '/testing' } }

        it { is_expected.to contain_file('access_conf').with_path('/testing') }
      end

      context 'with access_conf_owner set to a valid string' do
        let(:params) { { access_conf_owner: 'tester' } }

        it { is_expected.to contain_file('access_conf').with_owner('tester') }
      end

      context 'with access_conf_group set to a valid string' do
        let(:params) { { access_conf_group: 'tester' } }

        it { is_expected.to contain_file('access_conf').with_group('tester') }
      end

      context 'with access_conf_mode set to a valid string' do
        let(:params) { { access_conf_mode: '0242' } }

        it { is_expected.to contain_file('access_conf').with_mode('0242') }
      end

      context 'with access_conf_template set to a valid string' do
        let(:params) { { access_conf_template: 'pam/unit_tests.erb' } }

        it { is_expected.to contain_file('access_conf').with_content('dummy template for unit tests only') }
      end

      context 'with allowed_users set to a valid string for one user' do
        let(:params) { { allowed_users: 'tester' } }

        it { is_expected.to contain_file('access_conf').with_content(%r{^# allow only the groups listed\n\+:tester:ALL\n\n# default deny}) }
      end

      context 'with allowed_users set to a valid array for two users' do
        let(:params) { { allowed_users: [ 'spec', 'tester' ] } }

        it { is_expected.to contain_file('access_conf').with_content(%r{^# allow only the groups listed\n\+:spec:ALL\n\+:tester:ALL\n\n# default deny}) }
      end

      context 'with allowed_users set to a valid hash for two users with specific origins' do
        let(:params) { { allowed_users: { 'spec' => 'cron', 'tester' => [ 'cron', 'tty0' ] } } }

        it { is_expected.to contain_file('access_conf').with_content(%r{^# allow only the groups listed\n\+:spec:cron\n\+:tester:cron tty0\n\n# default deny}) }
      end

      context 'with allowed_users set to a valid hash for one users without specific origins should default to <ALL>' do
        let(:params) { { allowed_users: { 'tester' => {} } } }

        it { is_expected.to contain_file('access_conf').with_content(%r{^# allow only the groups listed\n\+:tester:ALL\n\n# default deny}) }
      end

      context 'with allowed_users set to a valid hash for five users with all possible cases' do
        let(:params) { { allowed_users: { 'user1' => 'tty5', 'user2' => ['cron', 'tty0'], 'user3' => 'cron', 'user4' => 'tty0', 'user5' => {} } } }

        content = <<-END.gsub(%r{^\s+\|}, '')
          |# This file is being maintained by Puppet.
          |# DO NOT EDIT
          |#
          |
          |# allow only the groups listed
          |+:user1:tty5
          |+:user2:cron tty0
          |+:user3:cron
          |+:user4:tty0
          |+:user5:ALL
          |
          |# default deny
          |-:ALL:ALL
        END

        it { is_expected.to contain_file('access_conf').with_content(content) }
      end
    end
  end
end
