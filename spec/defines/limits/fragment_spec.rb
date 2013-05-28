require 'spec_helper'

describe 'pam::limits::fragment' do
  context 'should create 80-nproc limits file' do
    let(:title) { '80-nproc' }
    let(:params) {
      { :source => 'puppet:///modules/pam/example.conf' }
    }
    let(:facts) {
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '5',
      }
    }

    it { should include_class('pam') }
    it { should include_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'source' => 'puppet:///modules/pam/example.conf',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    }
  end
end
