# For SLED/SLES we need individual tests for each affected minor release.
# Since this is not possible with rspec-puppet-facts, explicit tests are
# necessary here.

require 'spec_helper'
describe 'pam' do
  platforms = {
    'SLES-15.0' => {
      os: {
        release: {
          full: '15.0',
          major: '15',
        }
      }
    },
    'SLES-15.1' => {
      os: {
        release: {
          full: '15.1',
          major: '15',
        }
      }
    },
    'SLES-15.2' => {
      os: {
        release: {
          full: '15.2',
          major: '15',
        }
      }
    },
    'SLES-15.3' => {
      os: {
        release: {
          full: '15.3',
          major: '15',
        }
      }
    },
    'SLES-15.4' => {
      os: {
        release: {
          full: '15.4',
          major: '15',
        }
      }
    },
  }

  # useed on Suse until 15.3
  sshd_content_old = <<-END.gsub(%r{^\s+\|}, '')
    |#%PAM-1.0
    |auth      requisite  pam_nologin.so
    |auth      include    common-auth
    |account   requisite  pam_nologin.so
    |account   include    common-account
    |password  include    common-password
    |session   required   pam_loginuid.so
    |session   include    common-session
    |session   optional   pam_lastlog.so  silent noupdate showfailed
  END
  login_content_old = <<-END.gsub(%r{^\s+\|}, '')
    |#%PAM-1.0
    |auth      requisite  pam_nologin.so
    |auth      include    common-auth
    |account   include    common-account
    |password  include    common-password
    |session   required   pam_loginuid.so
    |session   include    common-session
    |#session   optional   pam_lastlog.so nowtmp showfailed
    |session   optional   pam_mail.so standard
  END

  # useed on Suse since 15.4
  sshd_content_new = <<-END.gsub(%r{^\s+\|}, '')
    |#%PAM-1.0
    |auth      requisite  pam_nologin.so
    |auth      include    common-auth
    |account   requisite  pam_nologin.so
    |account   include    common-account
    |password  include    common-password
    |session   required   pam_loginuid.so
    |session   include    common-session
    |session   optional   pam_lastlog.so  silent noupdate showfailed
    |session   optional   pam_keyinit.so force revoke
  END
  login_content_new = <<-END.gsub(%r{^\s+\|}, '')
    |#%PAM-1.0
    |auth      requisite  pam_nologin.so
    |auth      include    common-auth
    |account   include    common-account
    |password  include    common-password
    |session   optional   pam_keyinit.so force revoke
    |session   required   pam_loginuid.so
    |session   include    common-session
    |#session   optional   pam_lastlog.so nowtmp showfailed
    |session   optional   pam_mail.so standard
  END

  describe 'with default values for parameters' do
    platforms.sort.each do |osname, v|
      context "on OS #{osname}" do
        let :facts do
          {
            operatingsystem:        'SLES',
            os: {
              family:               'Suse',
              name:                 'SLES',
              release: {
                full:               v[:os][:release][:full],
                major:              v[:os][:release][:major],
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }

        if v[:os][:release][:full].to_f < 15.4
          it { is_expected.to contain_file('pam_d_sshd').with_content(sshd_content_old) }
          it { is_expected.to contain_file('pam_d_login').with_content(login_content_old) }
        else
          it { is_expected.to contain_file('pam_d_sshd').with_content(sshd_content_new) }
          it { is_expected.to contain_file('pam_d_login').with_content(login_content_new) }
        end
      end
    end
  end
end
