require 'spec_helper'

describe 'nsswitch' do

  describe 'included class' do
    context 'with defaults' do
      it {
        should include_class('nsswitch')
        should contain_file('nsswitch_config_file').with({
          'ensure'  => 'file',
          'path'    => '/etc/nsswitch.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
        should contain_file('nsswitch_config_file').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT

passwd:     files [!NOTFOUND=return]
shadow:     files [!NOTFOUND=return]
group:      files

sudoers:    files [!NOTFOUND=return]

hosts:      files dns

bootparams: files
ethers:     files
netmasks:   files
networks:   files
protocols:  files
rpc:        files
services:   files
netgroup:   files
publickey:  files
automount:  files
aliases:    files
})
      }
    end

    context 'with ldap enabled' do
      let :params do
        { :ensure_ldap => 'present' }
      end

      it {
        should include_class('nsswitch')
        should contain_file('nsswitch_config_file').with({
          'ensure'  => 'file',
          'path'    => '/etc/nsswitch.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
        should contain_file('nsswitch_config_file').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT

passwd:     files [!NOTFOUND=return] ldap
shadow:     files [!NOTFOUND=return] ldap
group:      files ldap

sudoers:    files [!NOTFOUND=return] ldap

hosts:      files dns

bootparams: files
ethers:     files
netmasks:   files
networks:   files
protocols:  files ldap
rpc:        files
services:   files ldap
netgroup:   files ldap
publickey:  files
automount:  files ldap
aliases:    files
})
      }
    end

    context 'with config_file set' do
      let :params do
        { :config_file => '/path/to/nsswitch.conf' }
      end

      it {
        should include_class('nsswitch')
        should contain_file('nsswitch_config_file').with({
          'ensure'  => 'file',
          'path'    => '/path/to/nsswitch.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }
    end
  end
end
