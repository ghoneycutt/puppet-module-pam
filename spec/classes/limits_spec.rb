require 'spec_helper'

describe 'pam::limits' do

  let :facts do
    {
      :osfamily          => 'redhat',
      :lsbmajdistrelease => '5',
    }
  end
  it do
    should include_class('pam')
  end

  describe 'limits conf file' do
    context 'with class defaults' do
      it do
        should contain_file('limits_conf').with({
          'ensure' => 'file',
          'path'   => '/etc/security/limits.conf',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      end
    end

    context 'with config_file set' do
      let(:params) { {:config_file => '/etc/security/foo.conf'} }
      it do
        should contain_file('limits_conf').with({
          'ensure' => 'file',
          'path'   => '/etc/security/foo.conf',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      end
    end
  end
end
