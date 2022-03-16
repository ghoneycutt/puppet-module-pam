require 'spec_helper'
require 'spec_platforms'

describe 'pam::limits' do
  on_supported_os.each do |os, os_facts|
    # this function call mimic hiera data, it is sourced in from spec/spec_platforms.rb
    package_name = package_name(os)

    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('pam') }

      content = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |
        |# /etc/security/limits.conf
        |#
        |#Each line describes a limit for a user in the form:
        |#
        |#<domain>        <type>  <item>  <value>
        |#
        |#Where:
        |#<domain> can be:
        |#        - a user name
        |#        - a group name, with @group syntax
        |#        - the wildcard *, for default entry
        |#        - the wildcard %, can be also used with %group syntax,
        |#                 for maxlogin limit
        |#
        |#<type> can have the two values:
        |#        - "soft" for enforcing the soft limits
        |#        - "hard" for enforcing hard limits
        |#
        |#<item> can be one of the following:
        |#        - core - limits the core file size (KB)
        |#        - data - max data size (KB)
        |#        - fsize - maximum filesize (KB)
        |#        - memlock - max locked-in-memory address space (KB)
        |#        - nofile - max number of open file descriptors
        |#        - rss - max resident set size (KB)
        |#        - stack - max stack size (KB)
        |#        - cpu - max CPU time (MIN)
        |#        - nproc - max number of processes
        |#        - as - address space limit (KB)
        |#        - maxlogins - max number of logins for this user
        |#        - maxsyslogins - max number of logins on the system
        |#        - priority - the priority to run user process with
        |#        - locks - max number of file locks the user can hold
        |#        - sigpending - max number of pending signals
        |#        - msgqueue - max memory used by POSIX message queues (bytes)
        |#        - nice - max nice priority allowed to raise to values: [-20, 19]
        |#        - rtprio - max realtime priority
        |#
        |#<domain>      <type>  <item>         <value>
        |#
        |
        |#*               soft    core            0
        |#*               hard    rss             10000
        |#\@student        hard    nproc           20
        |#\@faculty        soft    nproc           20
        |#\@faculty        hard    nproc           50
        |#ftp             hard    nproc           0
        |#\@student        -       maxlogins       4
        |
        |# End of file
      END

      if (os_facts[:os]['family'] == 'Suse') && (os_facts[:os]['release']['major'] == '10')
        it { is_expected.not_to contain_exec('mkdir_p-/etc/security/limits.d') }
        it { is_expected.not_to contain_file('limits_d') }
      else
        it do
          is_expected.to contain_file('limits_d').with(
            'ensure'  => 'directory',
            'path'    => '/etc/security/limits.d',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0750',
            'purge'   => false,
            'recurse' => false,
          )
        end
        it do
          is_expected.to contain_file('limits_d').that_requires('Exec[mkdir_p-/etc/security/limits.d]')
        end

        it { is_expected.to contain_exec('mkdir_p-/etc/security/limits.d') }
        it do
          is_expected.to contain_file('limits_conf').with(
            'ensure'  => 'file',
            'path'    => '/etc/security/limits.conf',
            'source'  => nil,
            'content' => content,
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0640',
          )
        end

        package_name.sort.each do |pkg|
          it { is_expected.to contain_file('limits_d').that_requires("Package[#{pkg}]") }
          it { is_expected.to contain_file('limits_conf').that_requires("Package[#{pkg}]") }
        end
      end

      context 'with config_file set to a valid path' do
        let(:params) { { config_file: '/testing' } }

        it { is_expected.to contain_file('limits_conf').with_path('/testing') }
      end

      context 'with config_file_lines set to a valid array' do
        let(:params) { { config_file_lines: [ '* soft nofile 2048', '* hard nofile 8192' ] } }

        it { is_expected.to contain_file('limits_conf').with_content(%r{\* soft nofile 2048\n\* hard nofile 8192\n}) }
      end

      context 'with config_file_source set to a valid string' do
        let(:params) { { config_file_source: 'puppet:///pam/unit_tests.erb' } }

        it { is_expected.to contain_file('limits_conf').with_source('puppet:///pam/unit_tests.erb') }
        it { is_expected.to contain_file('limits_conf').with_content(nil) }
      end

      context 'with config_file_lines and config_file_source both set to valid strings (config_file_lines takes priority)' do
        let(:params) do
          {
            config_file_lines: [ '* soft nofile 2048', '* hard nofile 8192' ],
            config_file_source: 'pam/unit_tests.erb',
          }
        end

        it { is_expected.to contain_file('limits_conf').with_source(nil) }
        it { is_expected.to contain_file('limits_conf').with_content(%r{\* soft nofile 2048\n\* hard nofile 8192\n}) }
      end

      context 'with config_file_mode set to a valid string' do
        let(:params) { { config_file_mode: '0242' } }

        it { is_expected.to contain_file('limits_conf').with_mode('0242') }
      end

      context 'with limits_d_dir set to a valid string' do
        let(:params) { { limits_d_dir: '/testing.d' } }

        it { is_expected.to contain_exec('mkdir_p-/testing.d') }
        it { is_expected.to contain_file('limits_d').with_path('/testing.d') }
        it { is_expected.to contain_file('limits_d').that_requires('Exec[mkdir_p-/testing.d]') }
      end

      context 'with limits_d_dir_mode set to a valid string' do
        let(:params) { { limits_d_dir_mode: '0242' } }

        it { is_expected.to contain_file('limits_d').with_mode('0242') }
      end

      context 'with purge_limits_d_dir set to a valid boolean true' do
        let(:params) { { purge_limits_d_dir: true } }

        it { is_expected.to contain_file('limits_d').with_purge(true) }
        it { is_expected.to contain_file('limits_d').with_recurse(true) }
      end
    end
  end
end
