require 'spec_helper_acceptance'

describe 'pam' do
  context 'default' do
    it 'should work without errors' do
      pp = <<-EOS
      include ::pam
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    if fact('osfamily') == 'Debian'
      package_name = 'libpam0g'
    else
      package_name = 'pam'
    end

    describe package(package_name) do
      it { should be_installed }
    end

    describe file('/etc/pam.d/sshd') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should match /^account\s+required\s+pam_access.so$/ }
    end

    describe file('/etc/security/access.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should contain('+ : root : ALL').before('- : ALL : ALL') }
      it { should contain('- : ALL : ALL').after('\+ : root : ALL') }
    end

    describe file('/etc/security/limits.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 640 }
      its(:content) { should match /^$|^#/ }
    end
  end
end

