require 'spec_helper'
describe 'pam' do

  platforms = {
    'el5' =>
      {
        :facts_hash => {
          :osfamily => 'RedHat',
          :operatingsystemmajrelease => '5',
          :os => {
            "name" => "RedHat",
            "family" => "RedHat",
            "release" => {
              "major" => "5",
              "minor" => "10",
              "full" => "5.10"
            },
          },
        },
        :packages           => ['pam', 'util-linux', ],
        :files              => [
          { :prefix         => 'pam_system_',
            :types          => ['auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'el6' =>
      {
        :facts_hash => {
          :osfamily => 'RedHat',
          :operatingsystemmajrelease => '6',
          :os => {
            "name" => "RedHat",
            "family" => "RedHat",
            "release" => {
              "full" => "6.5",
              "minor" => "5",
              "major" => "6"
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['system_auth', 'password_auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'el7' =>
      {
        :facts_hash => {
          :osfamily => 'RedHat',
          :operatingsystemmajrelease => '7',
          :os => {
            "name" => "RedHat",
            "family" => "RedHat",
            "release" => {
              "major" => "7",
              "minor" => "0",
              "full" => "7.0.1406"
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['system_auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'suse9' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystemmajrelease => '9',
          :os => {
            "name" => "openSUSE",
            "family" => "Suse",
            "release" => {
              "major" => "9",
              "full" => "9.1",
              "minor" => "1"
            }
          },
        },
        :packages           => ['pam', 'pam-modules', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['other', ],
          }, ],
      },
    'suse10' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystemmajrelease => '10',
          :os => {
            "name" => "openSUSE",
            "family" => "Suse",
            "release" => {
              "major" => "10",
              "full" => "10.1",
              "minor" => "1"
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
          }, ],
      },
    'suse11' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystemmajrelease => '11',
          :os => {
            "name" => "openSUSE",
            "family" => "Suse",
            "release" => {
              "major" => "11",
              "full" => "11.1",
              "minor" => "1"
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'suse12' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystemmajrelease => '12',
          :os => {
            "name" => "openSUSE",
            "family" => "Suse",
            "release" => {
              "major" => "12",
              "full" => "12.1",
              "minor" => "1"
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'suse13' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystemmajrelease => '13',
          :os => {
            "name" => "openSUSE",
            "family" => "Suse",
            "release" => {
              "major" => "13",
              "full" => "13.1",
              "minor" => "1"
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'solaris9' =>
      {
        :facts_hash => {
          :osfamily => 'Solaris',
          :kernelrelease => '5.9',
          :os => {
            "name" => "Solaris",
            "family" => "Solaris",
            "release" => {
              "major" => "5",
              "minor" => "9",
              "full" => "5.9"
            }
          },
        },
        :packages           => ['pam_package', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['conf', ],
            :group          => 'sys',
            :dirpath        => '/etc/pam.',
          }, ],
      },
    'solaris10' =>
      {
        :facts_hash => {
          :osfamily => 'Solaris',
          :kernelrelease => '5.10',
          :os => {
            "name" => "Solaris",
            "family" => "Solaris",
            "release" => {
              "major" => "5",
              "minor" => "10",
              "full" => "5.10"
            }
          },
        },
        :packages           => ['pam_package', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['conf', ],
            :group          => 'sys',
            :dirpath        => '/etc/pam.',
          }, ],
      },
    'solaris11' =>
      {
        :facts_hash => {
          :osfamily => 'Solaris',
          :kernelrelease => '5.11',
          :os => {
            "name" => "Solaris",
            "family" => "Solaris",
            "release" => {
              "major" => "5",
              "minor" => "11",
              "full" => "5.11"
            },
          },
        },
        :packages           => ['pam_package', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['other', ],
            :group          => 'sys',
          }, ],
      },
    'ubuntu1204' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :os => {
            "release" => {
              "major" => "12.04",
              "full" => "12.04"
            },
            "name" => "Ubuntu",
            "family" => "Debian"
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
          }, ],
      },
    'ubuntu1404' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :os => {
            "release" => {
              "major" => "14.04",
              "full" => "14.04"
            },
            "name" => "Ubuntu",
            "family" => "Debian"
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
          }, ],
      },
    'ubuntu1604' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :os => {
            "release" => {
              "major" => "16.04",
              "full" => "16.04"
            },
            "name" => "Ubuntu",
            "family" => "Debian"
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
          }, ],
      },
    'debian7' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :os => {
            "name" => "Debian",
            "family" => "Debian",
            "release" => {
              "major" => "7",
              "minor" => "8",
              "full" => "7.8"
            },
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
          }, ],
      },
    'debian8' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :os => {
            "name" => "Debian",
            "family" => "Debian",
            "release" => {
              "major" => "8",
              "minor" => "0",
              "full" => "8.0"
            },
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
          }, ],
      }
  }
  unsupported_platforms = {
    'el4' =>
      {
        :facts_hash => {
          :osfamily => 'RedHat',
          :operatingsystemmajrelease => '4',
          :os => {
            "name" => "RedHat",
            "family" => "RedHat",
            "release" => {
              "major" => "4",
              "minor" => "10",
              "full" => "4.10"
            },
          },
        }
      },
    'debian6' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :os => {
            "name" => "Debian",
            "family" => "Debian",
            "release" => {
              "major" => "6",
              "minor" => "8",
              "full" => "6.8"
            },
          },
        }
      },
    'suse8' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystemmajrelease => '8',
          :os => {
            "name" => "openSUSE",
            "family" => "Suse",
            "release" => {
              "major" => "8",
              "full" => "8.1",
              "minor" => "1"
            }
          },
        }
      },
    'ubuntu1004' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :os => {
            "release" => {
              "major" => "10.04",
              "full" => "10.04"
            },
            "name" => "Ubuntu",
            "family" => "Debian"
          },
        }
      },
    'solaris8' =>
      {
        :facts_hash => {
          :osfamily => 'Solaris',
          :kernelrelease => '5.8',
        }
      },
  }

  describe 'on unsupported platforms' do
    unsupported_platforms.sort.each do |k,v|
      context "with defaults params on #{k}" do
        let :facts do
          v[:facts_hash]
        end

        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error)
        end
      end
    end
  end

  describe 'packages' do
    platforms.sort.each do |k,v|
      context "with defaults params on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end

        if v[:facts_hash][:osfamily] == 'Solaris'
          v[:packages].each do |pkg|
            it {
              should_not contain_package(pkg)
            }
          end
        else
          v[:packages].each do |pkg|
            it {
              should contain_package(pkg).with({
                'ensure' => 'installed',
              })
            }
          end
        end
      end

      context "with specifying package_name on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) { {:package_name => 'foo'} }

        if v[:facts_hash][:osfamily] != 'Solaris'
          it {
            should contain_package('foo').with({
              'ensure' => 'installed',
            })
          }
        end
      end
    end
  end

  describe 'config files' do
    platforms.sort.each do |k,v|
      context "when configuring pam_d_sshd_template on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end

        let (:params) do
          { :pam_d_sshd_template     => 'pam/sshd.custom.erb',
            :pam_sshd_auth_lines     => [ 'auth_line1', 'auth_line2' ],
            :pam_sshd_account_lines  => [ 'account_line1', 'account_line2' ],
            :pam_sshd_session_lines  => [ 'session_line1', 'session_line2' ],
            :pam_sshd_password_lines => [ 'password_line1', 'password_line2' ],
          }
        end

        sshd_custom_content = <<-END.gsub(/^\s+\|/, '')
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
          it { should_not contain_file('pam_d_sshd') }
        else
          it { should contain_file('pam_d_sshd').with('content' => sshd_custom_content) }
        end
      end

      context "with specifying services param on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let (:params) { {:services => { 'testservice' => { 'content' => 'foo' } } } }

        it {
          should contain_file('pam.d-service-testservice').with({
            'ensure'  => 'file',
            'path'    => '/etc/pam.d/testservice',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
          })
        }

        it { should contain_file('pam.d-service-testservice').with_content('foo') }
      end

      context "with default params on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end

        v[:files].each do |file|
          group = file[:group] || 'root'
          dirpath = file[:dirpath] || '/etc/pam.d/'

          file[:types].each do |type|
            filename = "#{file[:prefix]}#{type}#{file[:suffix]}"
            path = "#{dirpath}#{file[:prefix]}#{type}#{file[:suffix]}"
            path.gsub! '_', '-'
            path.sub! 'pam-', ''
            path.sub! 'noninteractive-session', 'session-noninteractive'
            it {
              should contain_file(filename).with({
                'ensure'  => 'file',
                'path'    => path,
                'owner'   => 'root',
                'group'   => group,
                'mode'    => '0644',
              })
            }
            fixture = File.read(fixtures("#{filename}.defaults.#{k}"))
            it { should contain_file(filename).with_content(fixture) }

            v[:packages].sort.each do |pkg|
              if v[:facts_hash][:osfamily] != 'Solaris' and (v[:facts_hash][:osfamily] != 'Suse' and v[:facts_hash][:os] != 9)
                it { should contain_file(filename).that_requires("Package[#{pkg}]") }
              end
            end

            if file[:symlink]
              symlinkname = "#{file[:prefix]}#{type}"
              symlinkpath = "#{dirpath}#{file[:prefix]}#{type}"
              symlinkpath.gsub! '_', '-'
              symlinkpath.sub! 'pam-', ''
              it {
                should contain_file(symlinkname).with({
                  'ensure' => 'symlink',
                  'path'   => symlinkpath,
                  'owner'  => 'root',
                  'group'  => 'root',
                })
              }
              v[:packages].sort.each do |pkg|
                if v[:facts_hash][:osfamily] != 'Solaris'
                  it { should contain_file(filename).that_requires("Package[#{pkg}]") }
                end
              end
            end
          end

          if v[:facts_hash][:osfamily] == 'RedHat'
            if (v[:facts_hash][:os] == '6' or v[:facts_hash][:os] == '7')
                it {
                  should contain_file('pam_password_auth_ac').with({
                    'ensure' => 'file',
                    'path'   => '/etc/pam.d/password-auth-ac',
                    'owner'  => 'root',
                    'group'  => 'root',
                    'mode'   => '0644',
                  })
                }
                pam_password_auth_ac_fixture = File.read(fixtures("pam_password_auth_ac.defaults.#{k}"))
                it { should contain_file('pam_password_auth_ac').with_content(pam_password_auth_ac_fixture) }
            end
          end

          if v[:facts_hash][:osfamily] != 'Solaris'
            it {
              should contain_file('pam_d_login').with({
                'ensure' => 'file',
                'path'   => '/etc/pam.d/login',
                'owner'  => 'root',
                'group'  => 'root',
                'mode'   => '0644',
              })
            }
            pam_d_login_fixture = File.read(fixtures("pam_d_login.defaults.#{k}"))
            it { should contain_file('pam_d_login').with_content(pam_d_login_fixture) }

            it {
              should contain_file('pam_d_sshd').with({
                'ensure' => 'file',
                'path'   => '/etc/pam.d/sshd',
                'owner'  => 'root',
                'group'  => 'root',
                'mode'   => '0644',
              })
            }
            pam_d_sshd_fixture = File.read(fixtures("pam_d_sshd.defaults.#{k}"))
            it { should contain_file('pam_d_sshd').with_content(pam_d_sshd_fixture) }
          end
        end
      end

      context "with login_pam_access => sufficient on osfamily #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) {{ :login_pam_access => 'sufficient' }}

        if (v[:facts_hash][:osfamily] == 'RedHat') or (v[:facts_hash][:osfamily] == 'Suse' and v[:facts_hash][:os] == '11')
          it { should contain_file('pam_d_login').with_content(/account[\s]+sufficient[\s]+pam_access.so/) }
        end
      end

      context "with login_pam_access => absent on osfamily #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) {{ :login_pam_access => 'absent' }}

        if v[:facts_hash][:osfamily] != 'Solaris'
          it { should contain_file('pam_d_login').without_content(/^account.*pam_access.so$/) }
        end
      end

      context "with sshd_pam_access => sufficient on osfamily #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) {{ :sshd_pam_access => 'sufficient' }}

        if (v[:facts_hash][:osfamily] == 'RedHat') or (v[:facts_hash][:osfamily] == 'Suse' and v[:facts_hash][:os] == '11')
          it { should contain_file('pam_d_sshd').with_content(/^account[\s]+sufficient[\s]+pam_access.so$/) }
        end
      end

      context "with sshd_pam_access => absent on osfamily #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) {{ :sshd_pam_access => 'absent' }}

        if v[:facts_hash][:osfamily] != 'Solaris'
          it { should contain_file('pam_d_sshd').without_content(/^account.*pam_access.so$/) }
        end
      end

      context "with password_auth_ac => path on osfamily #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        if v[:facts_hash][:osfamily] == 'RedHat' and v[:facts_hash][:os] == '5'
          it { should_not contain_file('password_auth_ac') }
        end
      end

      context "with password_auth_ac_file => path on osfamily #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        if v[:facts_hash][:osfamily] == 'RedHat' and v[:facts_hash][:os] == '5'
          it { should_not contain_file('password_auth_ac_file') }
        end
      end

      context "with password_auth_ac_file => invalid/path on osfamily #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) {{ :password_auth_ac_file => 'invalid/path' }}

        if v[:facts_hash][:osfamily] == 'RedHat' and (v[:facts_hash][:os] == '6' or v[:facts_hash][:os] == '7')
          it 'should fail' do
            expect {
              should contain_class('pam')
            }.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/)
          end

        end
      end

      context "with password_auth_file => invalid/path on osfamily #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) {{ :password_auth_file => 'invalid/path' }}

        if v[:facts_hash][:osfamily] == 'RedHat' and (v[:facts_hash][:os] == '6' or v[:facts_hash][:os] == '7')
          it 'should fail' do
            expect {
              should contain_class('pam')
            }.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/)
          end

        end
      end
    end
  end

  describe 'validating params' do
    platforms.sort.slice(0,1).each do |k,v|
      ['required','requisite','sufficient','optional','absent'].each do |value|
        context "with login_pam_access set to valid value: #{value} on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
          let :facts do
            v[:facts_hash]
          end
          let(:params) {{ :login_pam_access => value }}

          it { should contain_class('pam') }
        end

        context "with sshd_pam_access set to valid value: #{value} on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
          let :facts do
            v[:facts_hash]
          end
          let(:params) {{ :sshd_pam_access => value }}

          it { should contain_class('pam') }
        end
      end

      context "with login_pam_access set to invalid value on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) {{ :login_pam_access => 'invalid' }}

        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/Enum\['absent', 'optional', 'required', 'requisite', 'sufficient'\]/)
        end
      end

      context "with sshd_pam_access set to invalid value on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) {{ :sshd_pam_access => 'invalid' }}

        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/Enum\['absent', 'optional', 'required', 'requisite', 'sufficient'\]/)
        end
      end

      context "with specifying services param as invalid type (non-hash) on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let (:params) { {:services => ['not', 'a', 'hash'] } }
        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error)
        end
      end

      context "with limits_fragments_hiera_merge parameter specified as a non-boolean or non-string on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let (:params) { {:limits_fragments_hiera_merge => ['not_a_boolean', 'not_a_string'] } }
        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/expects a Boolean value/)
        end
      end

      context "with limits_fragments_hiera_merge parameter specified as an invalid string on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
        let :facts do
          v[:facts_hash]
        end
        let (:params) { {:limits_fragments_hiera_merge => 'invalid_string' } }
        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/expects a Boolean value/)
        end
      end

      context "with manage_nsswitch parameter default value" do
        let :facts do
          v[:facts_hash]
        end
        it { is_expected.to contain_class('nsswitch') }
      end

      context "with manage_nsswitch parameter set to false" do
        let :facts do
          v[:facts_hash]
        end
        let(:params) { {:manage_nsswitch => false} }
        it { is_expected.not_to contain_class('nsswitch') }
      end

      [true,false].each do |value|
        context "with limits_fragments_hiera_merge parameter specified as a valid value: #{value} on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
          let :facts do
            v[:facts_hash]
          end
          let(:params) {{ :limits_fragments_hiera_merge => value }}

          it { should contain_class('pam') }
        end
      end

      [:pam_sshd_auth_lines, :pam_sshd_account_lines, :pam_sshd_password_lines, :pam_sshd_session_lines].each do |param|
        context "with pam_d_sshd_template set to pam/sshd.custom.erb when only #{param} is missing" do
          let :full_params do
            {
              :pam_sshd_auth_lines     => %w(auth_line1 auth_line2),
              :pam_sshd_account_lines  => %w(account_line1 account_line2),
              :pam_sshd_session_lines  => %w(session_line1 session_line2),
              :pam_sshd_password_lines => %w(password_line1 password_line2),
              :pam_d_sshd_template     => 'pam/sshd.custom.erb',
            }
          end
          let :facts do
            v[:facts_hash]
          end
          let(:params) {
            # remove param from full_params hash before applying
            full_params.delete(param)
            full_params
          }

          it 'should fail' do
            expect { should contain_class(subject) }.to raise_error(Puppet::Error, %r{pam_sshd_\[auth\|account\|password\|session\]_lines required when using the pam/sshd.custom.erb template})
          end
        end
      end

      [ :pam_sshd_auth_lines, :pam_sshd_account_lines, :pam_sshd_password_lines, :pam_sshd_session_lines ].each do |param|
        context "with #{param} specified and pam_d_sshd_template not specified on #{v[:facts_hash][:osfamily]} with os.release.major #{v[:facts_hash][:os]}" do
          let :facts do
            v[:facts_hash]
          end

          let(:params) { { param => [ '#' ] } }

          it "should fail" do
            expect {
              should contain_class('pam')
            }.to raise_error(Puppet::Error, %r{pam_sshd_\[auth\|account\|password\|session\]_lines are only valid when pam_d_sshd_template is configured with the pam/sshd.custom.erb template})
          end
        end
      end
    end
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      platforms['el7'][:facts_hash]
    end
    let(:mandatory_params) { {} }

    validations = {
      'array for pam_sshd_(auth|account|password|session)_lines' => {
        :name    => %w(pam_sshd_auth_lines pam_sshd_account_lines pam_sshd_password_lines pam_sshd_session_lines),
        :params  => { :pam_d_sshd_template => 'pam/sshd.custom.erb', :pam_sshd_auth_lines => ['#'], :pam_sshd_account_lines => ['#'], :pam_sshd_password_lines => ['#'], :pam_sshd_session_lines => ['#']},
        :valid   => [%w(array)],
        :invalid => ['string', { 'ha' => 'sh' }, 3, 2.42, true, false],
        :message => 'expects a value of type Undef or Array',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
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
