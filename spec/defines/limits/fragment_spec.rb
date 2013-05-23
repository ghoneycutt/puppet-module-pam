require 'spec_helper'

describe 'pam::limits::fragment' do
   let(:title) { 'foo' }
   let :params do
     { :source => 'bar' }
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
    context 'with custom fragment file' do
      it do
        should contain_file('/etc/security/limits.d/foo.conf').with({
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      end
    end
  end
end
