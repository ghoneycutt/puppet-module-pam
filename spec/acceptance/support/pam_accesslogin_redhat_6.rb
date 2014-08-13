shared_examples_for 'pam::accesslogin_redhat_6_basic' do
  describe file('/etc/security/access.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    expected_content = (<<EXPECTED).split(/\n/)
# This file is being maintained by Puppet.
# DO NOT EDIT
#

# allow only the groups listed
+ : root : ALL
+ : vagrant : ALL

# default deny
- : ALL : ALL
EXPECTED
    it { should contain(expected_content) }
  end
end
