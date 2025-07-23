require 'spec_helper'
require 'spec_platforms'

describe 'pam::pwhistory' do
  on_supported_os.each do |os, os_facts|
    # this function call mimic hiera data, it is sourced in from spec/spec_platforms.rb
    package_name = package_name(os)

    context "on #{os}" do
      let(:facts) { os_facts }
      let(:default_content) do
        <<-END.gsub(%r{^\s+\|}, '')
          |# This file is being maintained by Puppet.
          |# DO NOT EDIT
          |#
          |# Configuration for remembering the last passwords used by a user.
          |#
          |# Enable the debugging logs.
          |# Enabled if option is present.
          |# debug
          |#
          |# root account's passwords are also remembered.
          |# Enabled if option is present.
          |# enforce_for_root
          |#
          |# Number of passwords to remember.
          |# The default is 10.
          |# remember = 10
          |#
          |# Number of times to prompt for the password.
          |# The default is 1.
          |# retry = 1
          |#
          |# The directory where the last passwords are kept.
          |# The default is /etc/security/opasswd.
          |# file = /etc/security/opasswd
        END
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('pam') }

      it do
        is_expected.to contain_file('pwhistory.conf').with(
          'ensure'  => 'file',
          'path'    => '/etc/security/pwhistory.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'content' => default_content,
        )
      end

      package_name.sort.each do |pkg|
        it { is_expected.to contain_file('pwhistory.conf').that_requires("Package[#{pkg}]") }
      end

      context 'with config_file set to a valid path' do
        let(:params) { { config_file: '/custom/path.conf' } }

        it { is_expected.to contain_file('pwhistory.conf').with_path('/custom/path.conf') }
      end

      context 'with config_file_source set to a valid string' do
        let(:params) { { config_file_source: 'puppet:///modules/pam/custom.conf' } }

        it { is_expected.to contain_file('pwhistory.conf').with_source('puppet:///modules/pam/custom.conf') }
        it { is_expected.to contain_file('pwhistory.conf').with_content(nil) }
      end

      context 'with config_file_mode set to a valid string' do
        let(:params) { { config_file_mode: '0242' } }

        it { is_expected.to contain_file('pwhistory.conf').with_mode('0242') }
      end

      context 'with config_file_owner set to a valid string' do
        let(:params) { { config_file_owner: 'user1' } }

        it { is_expected.to contain_file('pwhistory.conf').with_owner('user1') }
      end

      context 'with config_file_group set to a valid string' do
        let(:params) { { config_file_group: 'group1' } }

        it { is_expected.to contain_file('pwhistory.conf').with_group('group1') }
      end

      context 'when all parameters are set' do
        let(:params) do
          {
            remember: 5,
            enforce_for_root: true,
            debug: true,
            retry: 2,
            file: '/custom/opasswd',
          }
        end

        let(:content) do
          <<-END.gsub(%r{^\s+\|}, '')
            |# This file is being maintained by Puppet.
            |# DO NOT EDIT
            |#
            |# Configuration for remembering the last passwords used by a user.
            |#
            |# Enable the debugging logs.
            |# Enabled if option is present.
            |debug
            |#
            |# root account's passwords are also remembered.
            |# Enabled if option is present.
            |enforce_for_root
            |#
            |# Number of passwords to remember.
            |# The default is 10.
            |remember = 5
            |#
            |# Number of times to prompt for the password.
            |# The default is 1.
            |retry = 2
            |#
            |# The directory where the last passwords are kept.
            |# The default is /etc/security/opasswd.
            |file = /custom/opasswd
          END
        end

        it { is_expected.to contain_file('pwhistory.conf').with_content(content) }
      end

      context 'when remember is set' do
        let(:params) { { remember: 7 } }

        let(:content) do
          <<-END.gsub(%r{^\s+\|}, '')
            |# This file is being maintained by Puppet.
            |# DO NOT EDIT
            |#
            |# Configuration for remembering the last passwords used by a user.
            |#
            |# Enable the debugging logs.
            |# Enabled if option is present.
            |# debug
            |#
            |# root account's passwords are also remembered.
            |# Enabled if option is present.
            |# enforce_for_root
            |#
            |# Number of passwords to remember.
            |# The default is 10.
            |remember = 7
            |#
            |# Number of times to prompt for the password.
            |# The default is 1.
            |# retry = 1
            |#
            |# The directory where the last passwords are kept.
            |# The default is /etc/security/opasswd.
            |# file = /etc/security/opasswd
          END
        end

        it { is_expected.to contain_file('pwhistory.conf').with_content(content) }
      end

      context 'when enforce_for_root is true' do
        let(:params) { { enforce_for_root: true } }

        let(:content) do
          <<-END.gsub(%r{^\s+\|}, '')
            |# This file is being maintained by Puppet.
            |# DO NOT EDIT
            |#
            |# Configuration for remembering the last passwords used by a user.
            |#
            |# Enable the debugging logs.
            |# Enabled if option is present.
            |# debug
            |#
            |# root account's passwords are also remembered.
            |# Enabled if option is present.
            |enforce_for_root
            |#
            |# Number of passwords to remember.
            |# The default is 10.
            |# remember = 10
            |#
            |# Number of times to prompt for the password.
            |# The default is 1.
            |# retry = 1
            |#
            |# The directory where the last passwords are kept.
            |# The default is /etc/security/opasswd.
            |# file = /etc/security/opasswd
          END
        end

        it { is_expected.to contain_file('pwhistory.conf').with_content(content) }
      end

      context 'when debug is true' do
        let(:params) { { debug: true } }

        let(:content) do
          <<-END.gsub(%r{^\s+\|}, '')
            |# This file is being maintained by Puppet.
            |# DO NOT EDIT
            |#
            |# Configuration for remembering the last passwords used by a user.
            |#
            |# Enable the debugging logs.
            |# Enabled if option is present.
            |debug
            |#
            |# root account's passwords are also remembered.
            |# Enabled if option is present.
            |# enforce_for_root
            |#
            |# Number of passwords to remember.
            |# The default is 10.
            |# remember = 10
            |#
            |# Number of times to prompt for the password.
            |# The default is 1.
            |# retry = 1
            |#
            |# The directory where the last passwords are kept.
            |# The default is /etc/security/opasswd.
            |# file = /etc/security/opasswd
          END
        end

        it { is_expected.to contain_file('pwhistory.conf').with_content(content) }
      end

      context 'when retry is set' do
        let(:params) { { retry: 3 } }

        let(:content) do
          <<-END.gsub(%r{^\s+\|}, '')
            |# This file is being maintained by Puppet.
            |# DO NOT EDIT
            |#
            |# Configuration for remembering the last passwords used by a user.
            |#
            |# Enable the debugging logs.
            |# Enabled if option is present.
            |# debug
            |#
            |# root account's passwords are also remembered.
            |# Enabled if option is present.
            |# enforce_for_root
            |#
            |# Number of passwords to remember.
            |# The default is 10.
            |# remember = 10
            |#
            |# Number of times to prompt for the password.
            |# The default is 1.
            |retry = 3
            |#
            |# The directory where the last passwords are kept.
            |# The default is /etc/security/opasswd.
            |# file = /etc/security/opasswd
          END
        end

        it { is_expected.to contain_file('pwhistory.conf').with_content(content) }
      end

      context 'when file is set' do
        let(:params) { { file: '/var/log/old_passwords' } }

        let(:content) do
          <<-END.gsub(%r{^\s+\|}, '')
            |# This file is being maintained by Puppet.
            |# DO NOT EDIT
            |#
            |# Configuration for remembering the last passwords used by a user.
            |#
            |# Enable the debugging logs.
            |# Enabled if option is present.
            |# debug
            |#
            |# root account's passwords are also remembered.
            |# Enabled if option is present.
            |# enforce_for_root
            |#
            |# Number of passwords to remember.
            |# The default is 10.
            |# remember = 10
            |#
            |# Number of times to prompt for the password.
            |# The default is 1.
            |# retry = 1
            |#
            |# The directory where the last passwords are kept.
            |# The default is /etc/security/opasswd.
            |file = /var/log/old_passwords
          END
        end

        it { is_expected.to contain_file('pwhistory.conf').with_content(content) }
      end
    end
  end
end
