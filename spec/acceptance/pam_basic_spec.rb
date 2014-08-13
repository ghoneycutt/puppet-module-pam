require 'spec_helper_acceptance'

describe 'pam class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'pam':
        allowed_users => ['root','vagrant'],      
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    os = fact('osfamily').downcase
    os_release = fact('operatingsystemmajrelease')

    it_behaves_like "pam_#{os}_#{os_release}_basic"
    it_behaves_like "pam::accesslogin_#{os}_#{os_release}_basic"
    it_behaves_like "pam::limits_#{os}_#{os_release}_basic"

  end
end
