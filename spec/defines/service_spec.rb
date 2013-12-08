require 'spec_helper'
describe 'pam::service' do
  context 'test' do
    let(:title) { 'ftp' }
    let(:params) {
      {:auth_directives => [{'control' => 'required',
                         'module-path' => 'pam_nologin.so',
                         'module-arguments' => 'no_warn'}]}
    }
    let(:facts) {
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    }

    it { should contain_class('pam') }

    it { should contain_file('pam.d-service-ftp').with({
        'ensure' => 'file',
        'path'   => '/etc/pam.d/ftp',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    }
    it { should contain_file('pam.d-service-ftp').with_content(/auth required pam_nologin.so no_warn/) }
  end
end
