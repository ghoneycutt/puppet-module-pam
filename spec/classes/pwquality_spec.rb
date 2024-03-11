require 'spec_helper'
require 'spec_platforms'

describe 'pam::pwquality' do
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
          |difok = 1
          |minlen = 8
          |dcredit = 0
          |ucredit = 0
          |lcredit = 0
          |ocredit = 0
          |minclass = 0
          |maxrepeat = 0
          |maxsequence = 0
          |maxclassrepeat = 0
          |gecoscheck = 0
          |dictcheck = 1
          |usercheck = 1
          |usersubstr = 0
          |enforcing = 1
          |retry = 1
        END
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('pam') }

      it do
        is_expected.to contain_file('pwquality.conf').with(
          'ensure'  => 'file',
          'path'    => '/etc/security/pwquality.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'source'  => nil,
          'content' => content,
        )
      end

      it do
        is_expected.to contain_file('pwquality.conf.d').with(
          'ensure'  => 'directory',
          'path'    => '/etc/security/pwquality.conf.d',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0755',
          'purge'   => true,
          'recurse' => true,
          'ignore'  => nil,
        )
      end

      package_name.sort.each do |pkg|
        it { is_expected.to contain_file('pwquality.conf').that_requires("Package[#{pkg}]") }
        it { is_expected.to contain_file('pwquality.conf.d').that_requires("Package[#{pkg}]") }
      end

      context 'with config_file set to a valid path' do
        let(:params) { { config_file: '/testing' } }

        it { is_expected.to contain_file('pwquality.conf').with_path('/testing') }
      end

      context 'with config_file_source set to a valid string' do
        let(:params) { { config_file_source: 'puppet:///pam/unit_tests.erb' } }

        it { is_expected.to contain_file('pwquality.conf').with_source('puppet:///pam/unit_tests.erb') }
        it { is_expected.to contain_file('pwquality.conf').with_content(nil) }
      end

      context 'with config_file_mode set to a valid string' do
        let(:params) { { config_file_mode: '0242' } }

        it { is_expected.to contain_file('pwquality.conf').with_mode('0242') }
      end

      context 'with config_d_dir set to a valid string' do
        let(:params) { { config_d_dir: '/testing.d' } }

        it { is_expected.to contain_file('pwquality.conf.d').with_path('/testing.d') }
      end

      context 'with config_d_dir_mode set to a valid string' do
        let(:params) { { config_d_dir_mode: '0242' } }

        it { is_expected.to contain_file('pwquality.conf.d').with_mode('0242') }
      end

      context 'with purge_config_d_dir set to a valid boolean false' do
        let(:params) { { purge_config_d_dir: false } }

        it { is_expected.to contain_file('pwquality.conf.d').with_purge(false) }
        it { is_expected.to contain_file('pwquality.conf.d').with_recurse(false) }

        context 'with purge_config_d_dir_ignore set to glob pattern' do
          let(:params) { { purge_config_d_dir: true, purge_config_d_dir_ignore: '{foo,bar}.conf' } }

          it { is_expected.to contain_file('pwquality.conf.d').with_ignore('{foo,bar}.conf') }
        end

        context 'with purge_config_d_dir_ignore set to array' do
          let(:params) { { purge_config_d_dir: true, purge_config_d_dir_ignore: ['foo.conf', 'bar.conf'] } }

          it { is_expected.to contain_file('pwquality.conf.d').with_ignore(['foo.conf', 'bar.conf']) }
        end

        context 'when non-default parameters passed' do
          let(:params) do
            {
              difok: 0,
              minlen: 10,
              dcredit: 1,
              ucredit: 2,
              lcredit: 3,
              ocredit: 4,
              minclass: 5,
              maxrepeat: 6,
              maxsequence: 7,
              maxclassrepeat: 8,
              gecoscheck: 9,
              dictcheck: 10,
              usercheck: 11,
              usersubstr: 12,
              enforcing: 13,
              badwords: ['foo', 'bar'],
              dictpath: '/etc/dict',
              retry: 14,
              enforce_for_root: true,
              local_users_only: true,
            }
          end
          let(:content) do
            <<-END.gsub(%r{^\s+\|}, '')
              |# This file is being maintained by Puppet.
              |# DO NOT EDIT
              |#
              |difok = 0
              |minlen = 10
              |dcredit = 1
              |ucredit = 2
              |lcredit = 3
              |ocredit = 4
              |minclass = 5
              |maxrepeat = 6
              |maxsequence = 7
              |maxclassrepeat = 8
              |gecoscheck = 9
              |dictcheck = 10
              |usercheck = 11
              |usersubstr = 12
              |enforcing = 13
              |badwords = foo bar
              |dictpath = /etc/dict
              |retry = 14
              |enforce_for_root
              |local_users_only
            END
          end

          it { is_expected.to contain_file('pwquality.conf').with_content(content) }
        end
      end
    end
  end
end
