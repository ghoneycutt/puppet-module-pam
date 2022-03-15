require 'spec_helper'
require 'spec_platforms'

describe 'pam' do
  on_supported_os.sort.each do |os, os_facts|
    # these function calls mimic hiera data, they are sourced in from spec/spec_platforms.rb
    os_id = os_id(os)
    packages = packages(os)
    files = files(os)
    files_suffix = files_suffix(os)
    pam_d_login = pam_d_login(os)
    pam_d_sshd = pam_d_sshd(os)
    symlink = symlink(os)
    dirpath = dirpath(os)
    group = group(os)

    context "on #{os} with module default settings" do
      let(:facts) { os_facts }

      file_header = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
      END

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('pam') }

      it { is_expected.to have_package_resource_count(packages.count) }
      packages.each do |package|
        it { is_expected.to contain_package(package).with_ensure('installed') }
      end

      files.each do |file|
        packages.sort.each do |package|
          it { is_expected.to contain_file(file + files_suffix).that_requires("Package[#{package}]") }
          if symlink == true
            it { is_expected.to contain_file(file).that_requires("Package[#{package}]") }
          end
        end

        it do
          is_expected.to contain_file(file + files_suffix).with(
            'ensure'  => 'file',
            'path'    => (dirpath + file + files_suffix).tr('_', '-').sub('pam-', ''),
            'content' => File.read(fixtures(os_id + '-' + file + files_suffix)),
            'owner'   => 'root',
            'group'   => group,
            'mode'    => '0644',
          )
        end

        next unless symlink == true
        it do
          is_expected.to contain_file(file).with(
            'ensure' => 'link',
            'path'   => (dirpath + file).tr('_', '-').sub('pam-', ''),
            'target' => (dirpath + file + files_suffix).tr('_', '-').sub('pam-', ''),
            'owner'  => 'root',
            'group'  => 'root',
          )
        end
      end

      if %r{solaris}.match?(os_id)
        it { is_expected.not_to contain_file('pam_d_login') }
        it { is_expected.not_to contain_file('pam_d_sshd') }
      else
        it do
          is_expected.to contain_file('pam_d_login').with(
            'ensure'  => 'file',
            'path'    => '/etc/pam.d/login',
            'content' => File.read(fixtures(os_id + '-pam_d_login')),
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
          )
        end

        it do
          is_expected.to contain_file('pam_d_sshd').with(
            'ensure'  => 'file',
            'path'    => '/etc/pam.d/sshd',
            'content' => File.read(fixtures(os_id + '-pam_d_sshd')),
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
          )
        end
      end

      unless %r{solaris}.match?(os_id)
        it { is_expected.to contain_class('pam::accesslogin') }
        it { is_expected.to contain_class('pam::limits') }
      end

      it { is_expected.to contain_class('nsswitch') }
      it { is_expected.to have_pam__service_resource_count(0) }
      it { is_expected.to have_pam__limits__fragment_resource_count(0) }

      context "with login_pam_access set to valid string sufficient on OS #{os}" do
        let(:params) { { login_pam_access: 'sufficient' } }

        if pam_d_login == false
          it { is_expected.to contain_file('pam_d_login').without_content(%r{account[\s]+sufficient[\s]+pam_access.so}) }
        elsif pam_d_login == true
          it { is_expected.to contain_file('pam_d_login').with_content(%r{^account[\s]+sufficient[\s]+pam_access.so$}) }
        else
          it { is_expected.not_to contain_file('pam_d_login') }
        end
      end

      context "with sshd_pam_access set to valid string sufficient on OS #{os}" do
        let(:params) { { sshd_pam_access: 'sufficient' } }

        if pam_d_sshd == false
          it { is_expected.to contain_file('pam_d_sshd').without_content(%r{account[\s]+sufficient[\s]+pam_access.so}) }
        elsif pam_d_sshd == true
          it { is_expected.to contain_file('pam_d_sshd').with_content(%r{^account[\s]+sufficient[\s]+pam_access.so$}) }
        else
          it { is_expected.not_to contain_file('pam_d_sshd') }
        end
      end

      context 'with allowed_users set to a valid hash with two users' do
        let(:params) { { allowed_users: { 'user1' => ['cron', 'tty0'], 'user2' => ['test1', 'test2'] } } }

        content = <<-END.gsub(%r{^\s+\|}, '')
          |#
          |
          |# allow only the groups listed
          |+:user1:cron tty0
          |+:user2:test1 test2
          |
          |# default deny
          |-:ALL:ALL
        END

        if %r{solaris}.match?(os_id)
          it { is_expected.not_to contain_file('access_conf') }
        else
          it { is_expected.to contain_file('access_conf').with_content(file_header + content) }
        end
      end

      describe 'config files' do
        context 'when configuring pam_d_sshd_template' do
          let(:params) do
            {
              pam_d_sshd_template: 'pam/sshd.custom.erb',
              pam_sshd_auth_lines: ['auth_line1', 'auth_line2'],
              pam_sshd_account_lines: ['account_line1', 'account_line2'],
              pam_sshd_session_lines: ['session_line1', 'session_line2'],
              pam_sshd_password_lines: ['password_line1', 'password_line2'],
            }
          end

          sshd_custom_content = <<-END.gsub(%r{^\s+\|}, '')
            |# This file is being maintained by Puppet.
            |# DO NOT EDIT
            |#
            |auth_line1
            |auth_line2
            |account_line1
            |account_line2
            |password_line1
            |password_line2
            |session_line1
            |session_line2
          END

          if %r{solaris}.match?(os_id)
            it { is_expected.not_to contain_file('pam_d_sshd') }
          else
            it { is_expected.to contain_file('pam_d_sshd').with_content(sshd_custom_content) }
          end
        end

        context 'with specifying services param' do
          let(:params) { { services: { 'testservice' => { 'content' => 'foo' } } } }

          it do
            is_expected.to contain_file('pam.d-service-testservice').with(
              'ensure'  => 'file',
              'path'    => '/etc/pam.d/testservice',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
            )
          end

          it { is_expected.to contain_file('pam.d-service-testservice').with_content('foo') }
        end

        context 'with login_pam_access => absent' do
          let(:params) { { login_pam_access: 'absent' } }

          unless %r{solaris}.match?(os_id)
            it { is_expected.to contain_file('pam_d_login').without_content(%r{^account.*pam_access.so$}) }
          end
        end

        context 'with sshd_pam_access => absent' do
          let(:params) { { sshd_pam_access: 'absent' } }

          unless %r{solaris}.match?(os_id)
            it { is_expected.to contain_file('pam_d_sshd').without_content(%r{^account.*pam_access.so$}) }
          end
        end

        context 'with password_auth_ac => path' do
          if %r{redhat-5}.match?(os_id)
            it { is_expected.not_to contain_file('password_auth_ac') }
          end
        end

        context 'with password_auth_ac_file => path' do
          if %r{redhat-5}.match?(os_id)
            it { is_expected.not_to contain_file('password_auth_ac_file') }
          end
        end

        context 'with pam_d_login_oracle_options set to valid array' do
          let(:params) { { pam_d_login_oracle_options: [ 'session required pam_spectest.so', 'session optional pam_spectest.so' ] } }

          if %r{redhat-5}.match?(os_id)
            it { is_expected.to contain_file('pam_d_login').with_content(%r{^# oracle options\nsession required pam_spectest.so\nsession optional pam_spectest.so$}) }
          elsif %r{solaris}.match?(os_id)
            it { is_expected.not_to contain_file('pam_d_login') }
          else
            it { is_expected.to contain_file('pam_d_login').without_content(%r{^# oracle options\nsession required pam_spectest.so\nsession optional pam_spectest.so$}) }
          end
        end
      end

      describe 'validating params' do
        ['required', 'requisite', 'sufficient', 'optional', 'absent'].each do |value|
          context "with login_pam_access set to valid value: #{value}" do
            let(:params) { { login_pam_access: value } }

            # /!\ need more specific test case
            it { is_expected.to contain_class('pam') }
          end

          context "with sshd_pam_access set to valid value: #{value}" do
            let(:params) { { sshd_pam_access: value } }

            # /!\ need more specific test case
            it { is_expected.to contain_class('pam') }
          end
        end

        context 'with manage_nsswitch parameter default value' do
          it { is_expected.to contain_class('nsswitch') }
        end

        context 'with manage_nsswitch parameter set to false' do
          let(:params) { { manage_nsswitch: false } }

          it { is_expected.not_to contain_class('nsswitch') }
        end

        [true, false].each do |value|
          context "with limits_fragments_hiera_merge parameter specified as a valid value: #{value}" do
            let(:params) { { limits_fragments_hiera_merge: value } }

            # /!\ need more specific test case
            it { is_expected.to contain_class('pam') }
          end
        end

        [:pam_sshd_auth_lines, :pam_sshd_account_lines, :pam_sshd_password_lines, :pam_sshd_session_lines].each do |param|
          context "with pam_d_sshd_template set to pam/sshd.custom.erb when only #{param} is missing" do
            let :full_params do
              {
                pam_sshd_auth_lines: ['auth_line1', 'auth_line2'],
                pam_sshd_account_lines: ['account_line1', 'account_line2'],
                pam_sshd_session_lines: ['session_line1', 'session_line2'],
                pam_sshd_password_lines: ['password_line1', 'password_line2'],
                pam_d_sshd_template: 'pam/sshd.custom.erb',
              }
            end
            let(:params) do
              # remove param from full_params hash before applying
              full_params.delete(param)
              full_params
            end

            it 'fails' do
              expect {
                is_expected.to contain_class(:subject)
              } .to raise_error(Puppet::Error, %r{pam_sshd_\[auth\|account\|password\|session\]_lines required when using the pam/sshd.custom.erb template})
            end
          end
        end

        [ :pam_sshd_auth_lines, :pam_sshd_account_lines, :pam_sshd_password_lines, :pam_sshd_session_lines ].each do |param|
          context "with #{param} specified and pam_d_sshd_template not specified" do
            let(:params) { { param => [ '#' ] } }

            it 'fails' do
              expect {
                is_expected.to contain_class(:subject)
              }.to raise_error(Puppet::Error, %r{pam_sshd_\[auth\|account\|password\|session\]_lines are only valid when pam_d_sshd_template is configured with the pam/sshd.custom.erb template})
            end
          end
        end
      end
    end
  end

  describe 'on unsupported platforms' do
    unsupported_platforms.sort.each do |k, v|
      context "with defaults params on #{k}" do
        let(:facts) { v[:facts_hash] }

        it { is_expected.to compile.and_raise_error(%r{must be}) }
      end
    end
  end
end
