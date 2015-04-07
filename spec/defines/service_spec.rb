require 'spec_helper'
describe 'pam::service', :type => :define do
  context 'on a RedHat OS' do
    let(:facts) {
      {
        :osfamily                   => 'RedHat',
        :operatingsystemmajrelease  => '5',
      }
    }

    context 'with no parameters' do
      let(:title) { 'test' }

      it { should contain_class('pam') }

      it {
        should contain_file('pam.d-service-test').with({
          'ensure'  => 'file',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'content' => nil,
        })
      }
    end

    context 'when absent' do
      let(:title) { 'test' }
      let(:params) { { :ensure => 'absent' } }

      it {
        should contain_file('pam.d-service-test').with({
          'ensure'  => 'absent',
        })
      }
    end

    context 'when given content' do
      let(:title) { 'test' }
      let(:params) { { :content => 'session required pam_permit.so' } }

      it { should contain_file('pam.d-service-test').with_content(
        %{session required pam_permit.so}
      ) }
    end

    context 'when given an array of lines' do
      let(:title) { 'test' }
      let(:params) do
        {
          :lines  => [
            '@include common-auth',
            '@include common-account',
            'session required pam_permit.so',
            'session required pam_limits.so',
          ],
        }
      end

      it { should contain_file('pam.d-service-test').with_content(
        %{# This file is being maintained by Puppet.
# DO NOT EDIT
@include common-auth
@include common-account
session required pam_permit.so
session required pam_limits.so
}
      ) }
    end
  end
end
