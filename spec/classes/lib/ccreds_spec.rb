require 'spec_helper'
describe 'pam::lib::ccreds', :type => :class do
  context 'on a RedHat OS' do
    let(:facts) {
      {
        :osfamily                   => 'RedHat',
        :operatingsystemmajrelease  => '5',
      }
    }
    context 'with no parameters' do
      it { should contain_package('pam_ccreds').with(
        'ensure'  => 'installed'
      ) }
    end
    context 'when absent' do
      let :params do
          {
            :ensure  => 'absent'
          }
        end
      it { should contain_package('pam_ccreds').with(
        'ensure'  => 'absent'
      ) }
    end
    context 'when given a custom package' do
      let :params do
          {
            :package  => 'libpam-magic-pkg'
          }
        end
      it { should contain_package('libpam-magic-pkg') }
    end
  end
  context 'on a Suse OS' do
    let(:facts) {
      {
        :osfamily          => 'Suse',
        :lsbmajdistrelease => '10',
      }
    }
    context 'with no parameters' do
      it { should contain_package('pam_ccreds').with(
        'ensure'  => 'installed'
      ) }
    end
    context 'when absent' do
      let :params do
          {
            :ensure  => 'absent'
          }
        end
      it { should contain_package('pam_ccreds').with(
        'ensure'  => 'absent'
      ) }
    end
    context 'when given a custom package' do
      let :params do
          {
            :package  => 'libpam-magic-pkg'
          }
        end
      it { should contain_package('libpam-magic-pkg') }
    end
  end
  context 'on a Ubuntu OS' do
    let(:facts) {
      {
        :osfamily       => 'Debian',
        :lsbdistrelease => '12.04',
        :lsbdistid      => 'Ubuntu',
      }
    }
    context 'with no parameters' do
      it { should contain_package('libpam-ccreds').with(
        'ensure'  => 'installed'
      ) }
    end
    context 'when absent' do
      let :params do
          {
            :ensure  => 'absent'
          }
        end
      it { should contain_package('libpam-ccreds').with(
        'ensure'  => 'absent'
      ) }
    end
    context 'when given a custom package' do
      let :params do
          {
            :package  => 'libpam-magic-pkg'
          }
        end
      it { should contain_package('libpam-magic-pkg') }
    end
  end
  context 'on a Solaris OS' do
    let(:facts) {
      {
        :osfamily      => 'Solaris',
        :kernelrelease => '5.11',
      }
    }
    context 'with no parameters' do
      it { should raise_error(Puppet::Error, /a custom PAM ccreds module package is required for Solaris/) }
    end
    context 'when absent' do
      let :params do
          {
            :ensure  => 'absent',
          }
        end
      it { should raise_error(Puppet::Error, /a custom PAM ccreds module package is required for Solaris/) }
    end
    context 'when absent with custom package' do
      let :params do
          {
            :ensure  => 'absent',
            :package  => 'libpam-magic-pkg',
          }
        end
      it { should contain_package('libpam-magic-pkg').with(
        'ensure'  => 'absent'
      ) }
    end
    context 'when given a custom package' do
      let :params do
          {
            :package  => 'libpam-magic-pkg'
          }
        end
      it { should contain_package('libpam-magic-pkg') }
    end
  end
end
