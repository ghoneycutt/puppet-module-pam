require 'spec_helper'
describe 'pam' do

  platforms = {
    'el5'                   =>
      { :osfamily           => 'RedHat',
        :release            => '5',
        :releasetype        => 'operatingsystemmajrelease',
        :packages           => ['pam', 'util-linux', ],
        :files              => [
          { :prefix         => 'pam_system_',
            :types          => ['auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'el6'                   =>
      { :osfamily           => 'RedHat',
        :release            => '6',
        :releasetype        => 'operatingsystemmajrelease',
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['system_auth', 'password_auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'el7'                   =>
      { :osfamily           => 'RedHat',
        :release            => '7',
        :releasetype        => 'operatingsystemmajrelease',
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['system_auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'suse9'                 =>
      { :osfamily           => 'Suse',
        :release            => '9',
        :releasetype        => 'lsbmajdistrelease',
        :packages           => ['pam', 'pam-modules', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['other', ],
          }, ],
      },
    'suse10'                =>
      { :osfamily           => 'Suse',
        :release            => '10',
        :releasetype        => 'lsbmajdistrelease',
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
          }, ],
      },
    'suse11'                =>
      { :osfamily           => 'Suse',
        :release            => '11',
        :releasetype        => 'lsbmajdistrelease',
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'suse12'                =>
      { :osfamily           => 'Suse',
        :release            => '12',
        :releasetype        => 'lsbmajdistrelease',
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'suse13'                =>
      { :osfamily           => 'Suse',
        :release            => '13',
        :releasetype        => 'lsbmajdistrelease',
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'solaris9'              =>
      { :osfamily           => 'Solaris',
        :release            => '5.9',
        :releasetype        => 'kernelrelease',
        :packages           => ['pam_package', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['conf', ],
            :group          => 'sys',
            :dirpath        => '/etc/pam.',
          }, ],
      },
    'solaris10'             =>
      { :osfamily           => 'Solaris',
        :release            => '5.10',
        :releasetype        => 'kernelrelease',
        :packages           => ['pam_package', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['conf', ],
            :group          => 'sys',
            :dirpath        => '/etc/pam.',
          }, ],
      },
    'solaris11'             =>
      { :osfamily           => 'Solaris',
        :release            => '5.11',
        :releasetype        => 'kernelrelease',
        :packages           => ['pam_package', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['other', ],
            :group          => 'sys',
          }, ],
      },
    'ubuntu1204'            =>
      { :osfamily           => 'Debian',
        :lsbdistid          => 'Ubuntu',
        :release            => '12.04',
        :releasetype        => 'lsbdistrelease',
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
          }, ],
      },
    'ubuntu1404'            =>
      { :osfamily           => 'Debian',
        :lsbdistid          => 'Ubuntu',
        :release            => '14.04',
        :releasetype        => 'lsbdistrelease',
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
          }, ],
      },
    'ubuntu1604'            =>
      { :osfamily           => 'Debian',
        :lsbdistid          => 'Ubuntu',
        :release            => '16.04',
        :releasetype        => 'lsbdistrelease',
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
          }, ],
      },
    'debian8'               =>
    { :osfamily             => 'Debian',
      :lsbdistid            => 'Debian',
      :release              => '8',
      :releasetype          => 'lsbmajdistrelease',
      :packages             => [ 'libpam0g', ],
      :files                => [
        { :prefix           => 'pam_common_',
          :types            => ['auth', 'account', 'password', 'session', 'noninteractive_session' ],
        }, ],
    }

  }
  unsupported_platforms = {
    'el4'                   =>
      { :osfamily           => 'RedHat',
        :release            => '4',
        :releasetype        => 'operatingsystemmajrelease',
      },
    'suse8'                 =>
      { :osfamily           => 'Suse',
        :release            => '8',
        :releasetype        => 'lsbmajdistrelease',
      },
    'debian7'               =>
      { :osfamily           => 'Debian',
        :release            => '7',
        :lsbdistid          => 'Debian',
        :releasetype        => 'lsbmajdistrelease',
      },
    'ubuntu1004'            =>
      { :osfamily           => 'Debian',
        :release            => '10.04',
        :lsbdistid          => 'Ubuntu',
        :releasetype        => 'lsbdistid',
      },
    'solaris8'              =>
      { :osfamily           => 'Solaris',
        :release            => '5.8',
        :releasetype        => 'kernelrelease',
      },
  }

  describe 'on unsupported platforms' do
    unsupported_platforms.sort.each do |k,v|
      context "with defaults params on #{k}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :lsbdistid => v[:lsbdistid],
            :"#{v[:releasetype]}" => v[:release],
          }
        end

        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/Pam is only supported on .* #{v[:releasetype]} .* <#{v[:release]}>/)
        end
      end
    end
  end

  describe 'packages' do
    platforms.sort.each do |k,v|
      context "with defaults params on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end

        if v[:osfamily] == 'Solaris'
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

      context "with specifying package_name on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let(:params) { {:package_name => 'foo'} }

        if v[:osfamily] != 'Solaris'
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
      context "when configuring pam_d_sshd_template on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
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

        if v[:osfamily] == 'Solaris'
          it { should_not contain_file('pam_d_sshd') }
        else
          it { should contain_file('pam_d_sshd').with('content' => sshd_custom_content) }
        end
      end

      context "with specifying services param on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
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

      ['defaults', 'vas'].each do |check|
        context "with #{check} params on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
          let :facts do
            { :osfamily => v[:osfamily],
              :"#{v[:releasetype]}" => v[:release],
              :lsbdistid => v[:lsbdistid],
            }
          end
          if check == 'vas'
            let(:params) { {:ensure_vas => 'present'} }
          end

          if check == 'vas' and v[:osfamily] == 'Suse' and v[:release] == '13'
            it 'should fail' do
              expect {
                should contain_class('pam')
              }.to raise_error(Puppet::Error,/Pam: vas is not supported on #{v[:osfamily]} #{v[:release]}/)
            end
            next
          end

          if check == 'vas' and v[:osfamily] == 'Debian' and v[:release] == '8'
            it 'should fail' do
              expect {
                should contain_class('pam')
              }.to raise_error(Puppet::Error,/Pam: vas is not supported on #{v[:osfamily]} #{v[:release]}/)
            end
            next
          end

          if check == 'vas' and v[:osfamily] == 'Debian' and v[:release] == '16.04'
            it 'should fail' do
              expect {
                should contain_class('pam')
              }.to raise_error(Puppet::Error,/Pam: vas is not supported on #{v[:lsbdistid]} #{v[:release]}/)
            end
            next
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
              fixture = File.read(fixtures("#{filename}.#{check}.#{k}"))
              it { should contain_file(filename).with_content(fixture) }

              v[:packages].sort.each do |pkg|
                if v[:osfamily] != 'Solaris' and (v[:osfamily] != 'Suse' and v[:release] != 9)
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
                  if v[:osfamily] != 'Solaris'
                    it { should contain_file(filename).that_requires("Package[#{pkg}]") }
                  end
                end
              end
            end

            if v[:osfamily] == 'RedHat'
              if (v[:release] == '6' or v[:release] == '7')
                  it {
                    should contain_file('pam_password_auth_ac').with({
                      'ensure' => 'file',
                      'path'   => '/etc/pam.d/password-auth-ac',
                      'owner'  => 'root',
                      'group'  => 'root',
                      'mode'   => '0644',
                    })
                  }
                  pam_password_auth_ac_fixture = File.read(fixtures("pam_password_auth_ac.#{check}.#{k}"))
                  it { should contain_file('pam_password_auth_ac').with_content(pam_password_auth_ac_fixture) }
              end
            end

            if v[:osfamily] != 'Solaris'
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
      end

      context "with login_pam_access => sufficient on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
          }
        end
        let(:params) {{ :login_pam_access => 'sufficient' }}

        if (v[:osfamily] == 'RedHat' and (v[:release] == '5' or v[:release] == '6')) or (v[:osfamily] == 'Suse' and v[:release] == '11')
          it { should contain_file('pam_d_login').with_content(/account[\s]+sufficient[\s]+pam_access.so/) }
        end
      end

      context "with login_pam_access => absent on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let(:params) {{ :login_pam_access => 'absent' }}

        if v[:osfamily] != 'Solaris'
          it { should contain_file('pam_d_login').without_content(/^account.*pam_access.so$/) }
        end
      end

      context "with sshd_pam_access => sufficient on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
          }
        end
        let(:params) {{ :sshd_pam_access => 'sufficient' }}

        if (v[:osfamily] == 'RedHat' and (v[:release] == '5' or v[:release] == '6')) or (v[:osfamily] == 'Suse' and v[:release] == '11')
          it { should contain_file('pam_d_sshd').with_content(/^account[\s]+sufficient[\s]+pam_access.so$/) }
        end
      end

      context "with sshd_pam_access => absent on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let(:params) {{ :sshd_pam_access => 'absent' }}

        if v[:osfamily] != 'Solaris'
          it { should contain_file('pam_d_sshd').without_content(/^account.*pam_access.so$/) }
        end
      end

      context "with password_auth_ac => path on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        if v[:osfamily] == 'RedHat' and v[:release] == '5'
          it { should_not contain_file('password_auth_ac') }
        end
      end

      context "with password_auth_ac_file => path on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        if v[:osfamily] == 'RedHat' and v[:release] == '5'
          it { should_not contain_file('password_auth_ac_file') }
        end
      end

      context "with password_auth_ac_file => invalid/path on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let(:params) {{ :password_auth_ac_file => 'invalid/path' }}

        if v[:osfamily] == 'RedHat' and (v[:release] == '6' or v[:release] == '7')
          it 'should fail' do
            expect {
              should contain_class('pam')
            }.to raise_error(Puppet::Error, /"invalid\/path" is not an absolute path/)
          end

        end
      end

      context "with password_auth_file => invalid/path on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let(:params) {{ :password_auth_file => 'invalid/path' }}

        if v[:osfamily] == 'RedHat' and (v[:release] == '6' or v[:release] == '7')
          it 'should fail' do
            expect {
              should contain_class('pam')
            }.to raise_error(Puppet::Error, /"invalid\/path" is not an absolute path/)
          end

        end
      end

      context "with ensure_vas => present and vas_major_version => 3 on osfamily #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let :params do
          { :ensure_vas => 'present',
            :vas_major_version => '3',
          }
        end

        if v[:osfamily] == 'RedHat' and (v[:release] == '5' or v[:release] == '6')
          it {
            should contain_file('pam_system_auth_ac').with({
              'ensure'  => 'file',
              'path'    => '/etc/pam.d/system-auth-ac',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
            })
          }

          v[:packages].sort.each do |pkg|
            it { should contain_file('pam_system_auth_ac').that_requires("Package[#{pkg}]") }
          end

          it { should contain_file('pam_system_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so.*store_creds/) }
          it { should contain_file('pam_system_auth_ac').with_content(/account[\s]+sufficient[\s]+pam_vas3.so/) }
          it { should contain_file('pam_system_auth_ac').with_content(/password[\s]+sufficient[\s]+pam_vas3.so/) }
          it { should contain_file('pam_system_auth_ac').with_content(/session[\s]+required[\s]+pam_vas3.so/) }
        end

        if v[:osfamily] == 'RedHat' and  v[:release] == '6'
          it {
            should contain_file('pam_password_auth_ac').with({
              'ensure'  => 'file',
              'path'    => '/etc/pam.d/password-auth-ac',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
            })
          }

          v[:packages].sort.each do |pkg|
            it { should contain_file('pam_password_auth_ac').that_requires("Package[#{pkg}]") }
          end

          it { should contain_file('pam_password_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so create_homedir get_nonvas_pass/) }
          it { should contain_file('pam_password_auth_ac').with_content(/account[\s]+sufficient[\s]+pam_vas3.so/) }
          it { should contain_file('pam_password_auth_ac').with_content(/password[\s]+sufficient[\s]+pam_vas3.so/) }
          it { should contain_file('pam_password_auth_ac').with_content(/session[\s]+required[\s]+pam_limits.so/) }
          it { should_not contain_file('pam_password_auth_ac').with_content(/auth[\s]+sufficient[\s]+pam_vas3.so.*store_creds/) }
        end

        if v[:osfamily] == 'Debian' and v[:lsbdistid] == 'Ubuntu' and v[:release] != '16.04'
          it { should contain_class('pam::accesslogin') }
          it { should contain_class('pam::limits') }

          ['auth', 'account', 'password', 'session'].each do |type|
            it {
              should contain_file("pam_common_#{type}").with({
                'ensure'  => 'file',
                'path'    => "/etc/pam.d/common-#{type}",
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644',
              })
            }
            pam_common_fixture = File.read(fixtures("pam_common_#{type}.vas.#{k}"))
            it { should contain_file("pam_common_#{type}").with_content(pam_common_fixture) }

            v[:packages].sort.each do |pkg|
              it { should contain_file("pam_common_#{type}").that_requires("Package[#{pkg}]") }
            end
          end

          it {
            should contain_file('pam_common_noninteractive_session').with({
              'ensure'  => 'file',
              'path'    => '/etc/pam.d/common-session-noninteractive',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
            })
          }
          pam_common_noninteractive_session_fixture = File.read(fixtures("pam_common_noninteractive_session.vas.#{k}"))
          it { should contain_file('pam_common_noninteractive_session').with_content(pam_common_noninteractive_session_fixture) }

          v[:packages].sort.each do |pkg|
            it { should contain_file("pam_common_noninteractive_session").that_requires("Package[#{pkg}]") }
          end
        end
      end
    end
  end

  describe 'validating versions' do
    platforms.sort.each do |k,v|
      context "with ensure_vas => present and unsupported vas_major_version on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let :params do
          {
            :ensure_vas        => 'present',
            :vas_major_version => '5',
          }
        end

        if v[:osfamily] == 'RedHat'
          if v[:release] == '5' or v[:release] == '6'
            it 'should fail' do
              expect {
                should contain_class('pam')
              }.to raise_error(Puppet::Error,/Pam is only supported with vas_major_version 3 or 4/)
            end
          else
            it 'should fail' do
              expect {
                should contain_class('pam')
              }.to raise_error(Puppet::Error,/Pam is only supported with vas_major_version 4 on EL7/)
            end
          end
        end
      end
    end
  end

  describe 'validating params' do
    platforms.sort.slice(0,1).each do |k,v|
      ['required','requisite','sufficient','optional','absent'].each do |value|
        context "with login_pam_access set to valid value: #{value} on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
          let :facts do
            { :osfamily => v[:osfamily],
              :"#{v[:releasetype]}" => v[:release],
              :lsbdistid => v[:lsbdistid],
            }
          end
          let(:params) {{ :login_pam_access => value }}

          it { should contain_class('pam') }
        end

        context "with sshd_pam_access set to valid value: #{value} on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
          let :facts do
            { :osfamily => v[:osfamily],
              :"#{v[:releasetype]}" => v[:release],
              :lsbdistid => v[:lsbdistid],
            }
          end
          let(:params) {{ :sshd_pam_access => value }}

          it { should contain_class('pam') }
        end
      end

      context "with login_pam_access set to invalid value on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let(:params) {{ :login_pam_access => 'invalid' }}

        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/pam::login_pam_access is <invalid> and must be either 'required', 'requisite', 'sufficient', 'optional' or 'absent'./)
        end
      end

      context "with sshd_pam_access set to invalid value on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let(:params) {{ :sshd_pam_access => 'invalid' }}

        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/pam::sshd_pam_access is <invalid> and must be either 'required', 'requisite', 'sufficient', 'optional' or 'absent'./)
        end
      end

      context "with specifying services param as invalid type (non-hash) on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
          }
        end
        let (:params) { {:services => ['not', 'a', 'hash'] } }
        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error)
        end
      end

      context "with limits_fragments_hiera_merge parameter specified as a non-boolean or non-string on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let (:params) { {:limits_fragments_hiera_merge => ['not_a_boolean', 'not_a_string'] } }
        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/is not a boolean/)
        end
      end

      context "with limits_fragments_hiera_merge parameter specified as an invalid string on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
        let :facts do
          { :osfamily => v[:osfamily],
            :"#{v[:releasetype]}" => v[:release],
            :lsbdistid => v[:lsbdistid],
          }
        end
        let (:params) { {:limits_fragments_hiera_merge => 'invalid_string' } }
        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error,/Unknown type of boolean given/)
        end
      end

      ['true',true,'false',false].each do |value|
        context "with limits_fragments_hiera_merge parameter specified as a valid value: #{value} on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
          let :facts do
            { :osfamily => v[:osfamily],
              :"#{v[:releasetype]}" => v[:release],
              :lsbdistid => v[:lsbdistid],
            }
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
            {
              :osfamily             => v[:osfamily],
              :"#{v[:releasetype]}" => v[:release],
              :lsbdistid            => v[:lsbdistid],
            }
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
        context "with #{param} specified and pam_d_sshd_template not specified on #{v[:osfamily]} with #{v[:releasetype]} #{v[:release]}" do
          let :facts do
            { :osfamily => v[:osfamily],
              :"#{v[:releasetype]}" => v[:release],
              :lsbdistid => v[:lsbdistid],
            }
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
      {
        :operatingsystemmajrelease => '7',
        :osfamily                  => 'RedHat',
      }
    end
    let(:mandatory_params) { {} }

    validations = {
      'array for pam_sshd_(auth|account|password|session)_lines' => {
        :name    => %w(pam_sshd_auth_lines pam_sshd_account_lines pam_sshd_password_lines pam_sshd_session_lines),
        :params  => { :pam_d_sshd_template => 'pam/sshd.custom.erb', :pam_sshd_auth_lines => ['#'], :pam_sshd_account_lines => ['#'], :pam_sshd_password_lines => ['#'], :pam_sshd_session_lines => ['#']},
        :valid   => [%w(array)],
        :invalid => ['string', { 'ha' => 'sh' }, 3, 2.42, true, false],
        :message => 'is not an Array',
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
