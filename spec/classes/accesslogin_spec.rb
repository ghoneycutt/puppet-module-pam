require 'spec_helper'
describe 'pam::accesslogin' do
  let(:facts) { platforms['el5'][:facts_hash] }

  context 'with default values on supported platform' do
    it { should compile.with_all_deps }

    it { should contain_class('pam') }

    content = <<-END.gsub(/^\s+\|/, '')
      |# This file is being maintained by Puppet.
      |# DO NOT EDIT
      |#
      |
      |# allow only the groups listed
      |+:root:ALL
      |
      |# default deny
      |-:ALL:ALL
    END

    it do
      should contain_file('access_conf').with({
        'ensure'  => 'file',
        'path'    => '/etc/security/access.conf',
        'content' => content,
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]', 'Package[util-linux]' ],
      })
    end
  end

  context 'with access_conf_path set to a valid path' do
    let(:params) { {:access_conf_path => '/testing'} }
    it { should contain_file('access_conf').with_path('/testing') }
  end

  context 'with access_conf_owner set to a valid string' do
    let(:params) { {:access_conf_owner => 'tester'} }
    it { should contain_file('access_conf').with_owner('tester') }
  end

  context 'with access_conf_group set to a valid string' do
    let(:params) { {:access_conf_group => 'tester'} }
    it { should contain_file('access_conf').with_group('tester') }
  end

  context 'with access_conf_mode set to a valid string' do
    let(:params) { {:access_conf_mode => '0242'} }
    it { should contain_file('access_conf').with_mode('0242') }
  end

  context 'with access_conf_template set to a valid string' do
    let(:params) { {:access_conf_template => 'pam/unit_tests.erb'} }
    it { should contain_file('access_conf').with_content('dummy template for unit tests only') }
  end

  context 'with allowed_users set to a valid string for one user' do
    let(:params) { {:allowed_users => 'tester'} }
    it { should contain_file('access_conf').with_content(%r{^# allow only the groups listed\n\+:tester:ALL\n\n# default deny}) }
  end

  context 'with allowed_users set to a valid array for two users' do
    let(:params) { {:allowed_users => [ 'spec', 'tester' ] } }
    it { should contain_file('access_conf').with_content(%r{^# allow only the groups listed\n\+:spec:ALL\n\+:tester:ALL\n\n# default deny}) }
  end

  context 'with allowed_users set to a valid hash for two users with specific origins' do
    let(:params) { {:allowed_users => { 'spec' => 'cron', 'tester' => [ 'cron', 'tty0' ] } } }
    it { should contain_file('access_conf').with_content(%r{^# allow only the groups listed\n\+:spec:cron\n\+:tester:cron tty0\n\n# default deny}) }
  end

  context 'with allowed_users set to a valid hash for one users without specific origins should default to <ALL>' do
    let(:params) { {:allowed_users => { 'tester' => {} } } }
    it { should contain_file('access_conf').with_content(%r{^# allow only the groups listed\n\+:tester:ALL\n\n# default deny}) }
  end

  context 'with allowed_users set to a valid hash for five users with all possible cases' do
    let(:params) { {:allowed_users => { 'user1' => 'tty5', 'user2' => ['cron', 'tty0'], 'user3' => 'cron', 'user4' => 'tty0', 'user5' => {}} } }
    content = <<-END.gsub(/^\s+\|/, '')
      |# This file is being maintained by Puppet.
      |# DO NOT EDIT
      |#
      |
      |# allow only the groups listed
      |+:user1:tty5
      |+:user2:cron tty0
      |+:user3:cron
      |+:user4:tty0
      |+:user5:ALL
      |
      |# default deny
      |-:ALL:ALL
    END

    it { should contain_file('access_conf').with_content(content) }
  end
end
