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

passwd:     files
shadow:     files
group:      files

sudoers:    files

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

passwd:     files ldap
shadow:     files ldap
group:      files ldap

sudoers:    files ldap

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

    context 'with vas enabled' do
      let :params do
        { :ensure_vas => 'present' }
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

passwd:     files vas4
shadow:     files
group:      files vas4

sudoers:    files

hosts:      files dns

bootparams: files
ethers:     files
netmasks:   files
networks:   files
protocols:  files
rpc:        files
services:   files
netgroup:   files nis
publickey:  files
automount:  files nis
aliases:    files
})
      }
    end

    context 'with vas and ldap both enabled' do
      let :params do
        {
          :ensure_ldap => 'present',
          :ensure_vas  => 'present',
        }
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

passwd:     files ldap vas4
shadow:     files ldap
group:      files ldap vas4

sudoers:    files ldap

hosts:      files dns

bootparams: files
ethers:     files
netmasks:   files
networks:   files
protocols:  files ldap
rpc:        files
services:   files ldap
netgroup:   files ldap nis
publickey:  files
automount:  files ldap nis
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

    context 'with config_file set to invalid value' do
      let :params do
        { :config_file => 'not/an/absolute/path' }
      end

      it do
        expect {
          should include_class('nsswitch')
        }.to raise_error(Puppet::Error)
      end
    end
  end
end
