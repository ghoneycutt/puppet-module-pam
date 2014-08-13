shared_examples_for 'pam::limits_redhat_6_basic' do
  describe file('/etc/security/limits.d') do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/security/limits.conf') do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /(^#|^$)/ }
  end
end
