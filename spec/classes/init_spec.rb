require 'spec_helper'
describe 'pam' do
  let(:facts) { platforms['el7'][:facts_hash] }

  file_header = <<-END.gsub(%r{^\s+\|}, '')
    |# This file is being maintained by Puppet.
    |# DO NOT EDIT
  END

  context 'with default values on supported platform EL7' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('pam') }
    it { is_expected.to contain_class('pam::accesslogin') }
    it { is_expected.to contain_class('pam::limits') }
    it { is_expected.to have_package_resource_count(1) }
    it { is_expected.to contain_package('pam').with_ensure('installed') }

    it do
      is_expected.to contain_file('pam_d_login').with(
        'ensure'  => 'file',
        'path'    => '/etc/pam.d/login',
        'content' => File.read(fixtures('pam_d_login.defaults.el7')),
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      )
    end

    it do
      is_expected.to contain_file('pam_d_sshd').with(
        'ensure'  => 'file',
        'path'    => '/etc/pam.d/sshd',
        'content' => File.read(fixtures('pam_d_sshd.defaults.el7')),
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      )
    end

    it { is_expected.to contain_class('nsswitch') }
    it { is_expected.to have_pam__service_resource_count(0) }
    it { is_expected.to have_pam__limits__fragment_resource_count(0) }

    it do
      is_expected.to contain_file('pam_password_auth_ac').with(
        'ensure'  => 'file',
        'path'    => '/etc/pam.d/password-auth-ac',
        'content' => File.read(fixtures('pam_password_auth_ac.defaults.el7')),
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]' ],
      )
    end

    it do
      is_expected.to contain_file('pam_password_auth').with(
        'ensure'  => 'link',
        'path'    => '/etc/pam.d/password-auth',
        'target'  => '/etc/pam.d/password-auth-ac',
        'owner'   => 'root',
        'group'   => 'root',
        'require' => ['Package[pam]'],
      )
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

  platforms.sort.each do |os, v|
    # testing platform dependent package_name and the dependencies on common_files
    context "defaults for package_name on OS #{os}" do
      let(:facts) { v[:facts_hash] }

      it { is_expected.to have_package_resource_count(v[:packages].count) }
      v[:packages].each do |pkg|
        it { is_expected.to contain_package(pkg).with_ensure('installed') }
      end

      # OS dependent package dependencies
      v[:files].each do |file|
        dirpath = file[:dirpath] || '/etc/pam.d/'

        file[:types].each do |type|
          filename = "#{file[:prefix]}#{type}#{file[:suffix]}"
          path = "#{dirpath}#{file[:prefix]}#{type}#{file[:suffix]}"
          path.tr! '_', '-'
          path.sub! 'pam-', ''
          symlinkname = "#{file[:prefix]}#{type}"
          symlinkpath = "#{dirpath}#{file[:prefix]}#{type}"
          symlinkpath.tr! '_', '-'
          symlinkpath.sub! 'pam-', ''

          v[:packages].sort.each do |pkg|
            it { is_expected.to contain_file(filename).that_requires("Package[#{pkg}]") }
            if file[:symlink]
              it { is_expected.to contain_file(symlinkname).that_requires("Package[#{pkg}]") }
            end
          end
        end
      end
    end

    # testing platform dependent common_files, common_files_suffix, common_files_create_links, pam_d_login_template, pam_d_sshd_template and content for pam_*_lines
    context "defaults for common_files on OS #{os}" do
      let(:facts) { v[:facts_hash] }

      v[:files].each do |file|
        group = file[:group] || 'root'
        dirpath = file[:dirpath] || '/etc/pam.d/'

        file[:types].each do |type|
          filename = "#{file[:prefix]}#{type}#{file[:suffix]}"
          path = "#{dirpath}#{file[:prefix]}#{type}#{file[:suffix]}"
          path.tr! '_', '-'
          path.sub! 'pam-', ''

          it do
            is_expected.to contain_file(filename).with(
              'ensure'  => 'file',
              'path'    => path,
              'content' => File.read(fixtures("#{filename}.defaults.#{os}")),
              'owner'   => 'root',
              'group'   => group,
              'mode'    => '0644',
            )
          end

          next unless file[:symlink]
          symlinkname   = "#{file[:prefix]}#{type}"
          symlinkpath   = "#{dirpath}#{file[:prefix]}#{type}"
          symlinkpath.tr! '_', '-'
          symlinkpath.sub! 'pam-', ''

          it do
            is_expected.to contain_file(symlinkname).with(
              'ensure' => 'link',
              'path'   => symlinkpath,
              'target' => path,
              'owner'  => 'root',
              'group'  => 'root',
            )
          end
        end

        if v[:facts_hash][:osfamily] != 'Solaris'
          it do
            is_expected.to contain_file('pam_d_login').with(
              'ensure'  => 'file',
              'path'    => '/etc/pam.d/login',
              'content' => File.read(fixtures("pam_d_login.defaults.#{os}")),
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
            )
          end

          it do
            is_expected.to contain_file('pam_d_sshd').with(
              'ensure'  => 'file',
              'path'    => '/etc/pam.d/sshd',
              'content' => File.read(fixtures("pam_d_sshd.defaults.#{os}")),
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
            )
          end
        else
          it { is_expected.not_to contain_file('pam_d_login') }
          it { is_expected.not_to contain_file('pam_d_sshd') }
        end
      end
    end

    context "with login_pam_access set to valid string sufficient on OS #{os}" do
      let(:facts) { v[:facts_hash] }
      let(:params) { { login_pam_access: 'sufficient' } }

      if v[:pam_d_login] == 'without_pam_access'
        it { is_expected.to contain_file('pam_d_login').without_content(%r{account[\s]+sufficient[\s]+pam_access.so}) }
      elsif v[:pam_d_login] == 'with_pam_access'
        it { is_expected.to contain_file('pam_d_login').with_content(%r{^account[\s]+sufficient[\s]+pam_access.so$}) }
      else
        it { is_expected.not_to contain_file('pam_d_login') }
      end
    end

    context "with sshd_pam_access set to valid string sufficient on OS #{os}" do
      let(:facts) { v[:facts_hash] }
      let(:params) { { sshd_pam_access: 'sufficient' } }

      if v[:pam_d_sshd] == 'without_pam_access'
        it { is_expected.to contain_file('pam_d_sshd').without_content(%r{account[\s]+sufficient[\s]+pam_access.so}) }
      elsif v[:pam_d_sshd] == 'with_pam_access'
        it { is_expected.to contain_file('pam_d_sshd').with_content(%r{^account[\s]+sufficient[\s]+pam_access.so$}) }
      else
        it { is_expected.not_to contain_file('pam_d_sshd') }
      end
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
    it { is_expected.to contain_file('access_conf').with_content(file_header + content) }
  end

  platforms.sort.each do |k, v|
    describe "on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
      let(:facts) { v[:facts_hash] }

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

          if v[:facts_hash][:osfamily] == 'Solaris'
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

          if v[:facts_hash][:osfamily] != 'Solaris'
            it { is_expected.to contain_file('pam_d_login').without_content(%r{^account.*pam_access.so$}) }
          end
        end

        context 'with sshd_pam_access => absent' do
          let(:params) { { sshd_pam_access: 'absent' } }

          if v[:facts_hash][:osfamily] != 'Solaris'
            it { is_expected.to contain_file('pam_d_sshd').without_content(%r{^account.*pam_access.so$}) }
          end
        end

        context 'with password_auth_ac => path' do
          let :facts do
            v[:facts_hash]
          end

          if (v[:facts_hash][:osfamily] == 'RedHat') && (v[:facts_hash][:os] == '5')
            it { is_expected.not_to contain_file('password_auth_ac') }
          end
        end

        context 'with password_auth_ac_file => path' do
          if (v[:facts_hash][:osfamily] == 'RedHat') && (v[:facts_hash][:os] == '5')
            it { is_expected.not_to contain_file('password_auth_ac_file') }
          end
        end

        context 'with pam_d_login_oracle_options set to valid array' do
          let(:params) { { pam_d_login_oracle_options: [ 'session required pam_spectest.so', 'session optional pam_spectest.so' ] } }

          if k == 'el5'
            it { is_expected.to contain_file('pam_d_login').with_content(%r{^# oracle options\nsession required pam_spectest.so\nsession optional pam_spectest.so$}) }
          elsif %r{solaris.*}.match?(k)
            it { is_expected.not_to contain_file('pam_d_login') }
          else
            it { is_expected.to contain_file('pam_d_login').without_content(%r{^# oracle options\nsession required pam_spectest.so\nsession optional pam_spectest.so$}) }
          end
        end
      end
    end
  end

  describe 'validating params' do
    platforms.sort.slice(0, 1).each do |_k, v|
      context "on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let(:facts) { v[:facts_hash] }

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
          context "with limits_fragments_hiera_merge parameter specified as a valid value: #{value} on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
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
          context "with #{param} specified and pam_d_sshd_template not specified on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
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
end
