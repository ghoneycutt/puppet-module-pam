require 'spec_helper_acceptance'

describe 'pam' do
  context 'default' do
    it 'works without errors' do
      pp = <<-EOS
      include pam
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    package_name = if fact('osfamily') == 'Debian'
                     'libpam0g'
                   else
                     'pam'
                   end

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe file('/etc/pam.d/login') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 644 }
      it {
        if fact('osfamily') == 'RedHat'
          if fact('operatingsystemmajrelease') == '8'
            is_expected.not_to match(%r{^account\s+required\s+pam_access.so$})
          else
            is_expected.to match(%r{^account\s+required\s+pam_access.so$})
          end
        end
      }
    end

    describe file('/etc/pam.d/sshd') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 644 }
      it {
        if fact('osfamily') == 'RedHat'
          if fact('operatingsystemmajrelease') == '8'
            is_expected.not_to match(%r{^account\s+required\s+pam_access.so$})
          else
            is_expected.to match(%r{^account\s+required\s+pam_access.so$})
          end
        end
      }
    end

    describe file('/etc/security/access.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 644 }
      it { is_expected.to contain('+:root:ALL').before('-:ALL:ALL') }
      it { is_expected.to contain('-:ALL:ALL').after('\+:root:ALL') }
    end

    describe file('/etc/security/limits.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 640 }
      its(:content) { is_expected.to match(%r{^$|^#}) }
    end

    if fact('osfamily') == 'RedHat'
      ['password-auth', 'system-auth'].each do |f|
        describe file("/etc/pam.d/#{f}-ac") do
          it { is_expected.to be_file }
          it { is_expected.to be_owned_by 'root' }
          it { is_expected.to be_grouped_into 'root' }
          it { is_expected.to be_mode 644 }
        end
        describe file("/etc/pam.d/#{f}") do
          it { is_expected.to be_symlink }
          it { is_expected.to be_linked_to "/etc/pam.d/#{f}-ac" }
        end
      end
    end

    if fact('osfamily') == 'Debian'
      ['auth', 'account', 'password', 'session', 'session-noninteractive'].each do |f|
        describe file("/etc/pam.d/common-#{f}") do
          it { is_expected.to be_file }
          it { is_expected.to be_owned_by 'root' }
          it { is_expected.to be_grouped_into 'root' }
          it { is_expected.to be_mode 644 }
        end
      end
    end
  end
end
