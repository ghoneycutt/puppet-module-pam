require 'spec_helper'

describe 'pam::service', type: :define do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }

      file_header = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
      END

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('pam') }

        it do
          is_expected.to contain_file('pam.d-service-test').with(
            'ensure' => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'content' => nil,
          )
        end
      end

      context 'with ensure set to a valid string present' do
        let(:params) { { ensure: 'present' } }

        it { is_expected.to contain_file('pam.d-service-test').with_ensure('file') }
      end

      context 'with ensure set to a valid string absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to contain_file('pam.d-service-test').with_ensure('absent') }
      end

      context 'with pam_config_dir set to a valid path /test/pam.d' do
        let(:params) { { pam_config_dir: '/test/pam.d' } }

        it { is_expected.to contain_file('pam.d-service-test').with_path('/test/pam.d/test') }
      end

      context 'with content set to a valid string session required pam_permit.so' do
        let(:params) { { content: 'session required pam_permit.so' } }

        it { is_expected.to contain_file('pam.d-service-test').with_content('session required pam_permit.so') }
      end

      context 'with lines set to a valid array [ @include common-auth, session required pam_permit.so ]' do
        let(:params) { { lines: [ '@include common-auth', 'session required pam_permit.so' ] } }

        it { is_expected.to contain_file('pam.d-service-test').with_content(file_header + "@include common-auth\nsession required pam_permit.so\n") }
      end

      context 'with content and lines both set to valid values' do
        let(:params) do
          {
            content: 'session required pam_permit.so',
            lines: [ '@include common-auth', 'session required pam_permit.so' ],
          }
        end

        it 'fails' do
          expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{pam::service expects one of the lines or contents parameters to be provided, but not both})
        end
      end
    end
  end
end
