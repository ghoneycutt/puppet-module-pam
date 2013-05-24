require 'spec_helper'

describe 'pam::limits::fragment' do
   let(:title) { 'foo' }
      let :params do
        { :source => 'puppet:///modules/pam/example.conf' }
      end
   let :facts do
    {
      :osfamily          => 'redhat',
      :lsbmajdistrelease => '5',
    }
  end
  it do
    should include_class('pam')
  end
  it do
    should include_class('pam::limits')
  end

  describe 'fragment config file' do
    context 'with no params' do
      it do
        should contain_file('/etc/security/limits.d/foo.conf').with({
          'ensure' => 'file',
          'source' => 'puppet:///modules/pam/example.conf',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      end
    end
  end
end
