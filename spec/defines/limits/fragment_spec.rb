require 'spec_helper'

describe 'pam::limits::fragment' do
  context 'create file from source when source is specified' do
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

    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'source'  => 'puppet:///modules/pam/example.conf',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }
  end

  context 'create file from template when list is specified' do
    let(:title) { '80-nproc' }
    let(:params) {
      { :list => ['* soft nproc 1024',
                  'root soft nproc unlimited',
                  '* soft cpu 720'] }
    }
    let(:facts) {
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '5',
      }
    }

    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }
    it { should contain_file('/etc/security/limits.d/80-nproc.conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
* soft nproc 1024
root soft nproc unlimited
* soft cpu 720
})
    }
  end

  context 'create file from template when list and source is specified' do
    let(:title) { '80-nproc' }
    let(:params) {
      { :list => ['* soft nproc 1024',
                  'root soft nproc unlimited',
                  '* soft cpu 720'],
        :source => 'puppet:///modules/pam/example.conf',
      }
    }
    let(:facts) {
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '5',
      }
    }

    it { should contain_class('pam') }
    it { should contain_class('pam::limits') }

    it {
      should contain_file('/etc/security/limits.d/80-nproc.conf').with({
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    }
    it { should contain_file('/etc/security/limits.d/80-nproc.conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
* soft nproc 1024
root soft nproc unlimited
* soft cpu 720
})
    }
  end

  context 'if neither source or list is specified' do
    let(:title) { '80-nproc' }
    let(:facts) {
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '5',
      }
    }

    it 'should fail' do
      expect {
        should contain_class('pam::limits')
      }.to raise_error(Puppet::Error,/pam::limits::fragment must specify source or list./)
    end
  end

  context 'on unsupported platform Suse 10.x' do
    let(:title) { '80-nproc' }
    let(:facts) {
      {
        :osfamily               => 'Suse',
        :lsbmajdistrelease      => '10',
      }
    }
    it 'should fail' do
      expect {
        should contain_class('pam::limits::fragment')
      }.to raise_error(Puppet::Error,/You can not use pam::limits::fragment together with Suse 10.x releases/)
    end
  end
end
