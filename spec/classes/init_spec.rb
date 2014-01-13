require 'spec_helper'
describe 'nsswitch' do

  it { should compile.with_all_deps }

  describe 'included class' do
    context 'with defaults' do
      it {
        should contain_class('nsswitch')
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
        should contain_class('nsswitch')
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
        should contain_class('nsswitch')
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

    context 'with vas enabled and vas_nss_module_passwd set' do
      let :params do
        {
          :ensure_vas            => 'present',
          :vas_nss_module_passwd => 'vas3 nis',
        }
      end

      it {
        should contain_class('nsswitch')
        should contain_file('nsswitch_config_file').with({
          'ensure'  => 'file',
          'path'    => '/etc/nsswitch.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
        should contain_file('nsswitch_config_file').with_content(/passwd:[\s]+files vas3 nis$/)
      }
    end

    context 'with vas enabled and vas_nss_module_group set' do
      let :params do
        {
          :ensure_vas           => 'present',
          :vas_nss_module_group => 'nis',
        }
      end

      it {
        should contain_file('nsswitch_config_file').with_content(/group:[\s]+files nis$/)
      }
    end

    context 'with vas enabled and vas_nss_module_netgroup set' do
      let :params do
        {
          :ensure_vas              => 'present',
          :vas_nss_module_netgroup => 'nisplus',
        }
      end

      it {
        should contain_file('nsswitch_config_file').with_content(/netgroup:[\s]+files nisplus$/)
      }
    end

    context 'with vas enabled and vas_nss_module_automount set' do
      let :params do
        {
          :ensure_vas               => 'present',
          :vas_nss_module_automount => 'nisplus',
        }
      end

      it {
        should contain_file('nsswitch_config_file').with_content(/automount:[\s]+files nisplus$/)
      }
    end

    context 'with vas enabled and vas_nss_module_automount set empty' do
      let :params do
        {
          :ensure_vas               => 'present',
          :vas_nss_module_automount => '',
        }
      end

      it {
        should contain_file('nsswitch_config_file').with_content(/automount:[\s]+files$/)
      }
    end

    context 'with vas enabled and vas_nss_module_aliases set' do
      let :params do
        {
          :ensure_vas             => 'present',
          :vas_nss_module_aliases => 'nis',
        }
      end

      it {
        should contain_file('nsswitch_config_file').with_content(/aliases:[\s]+files nis$/)
      }
    end

    context 'with vas enabled and vas_nss_module_services set' do
      let :params do
        {
          :ensure_vas              => 'present',
          :vas_nss_module_services => 'nis',
        }
      end

      it {
        should contain_file('nsswitch_config_file').with_content(/services:[\s]+files nis$/)
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
        should contain_class('nsswitch')
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
        should contain_class('nsswitch')
        should contain_file('nsswitch_config_file').with({
          'ensure'  => 'file',
          'path'    => '/path/to/nsswitch.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }
    end

    context 'with default options on osfamily Solaris' do
      let :facts do
      {
        :osfamily => 'Solaris',
      }
      end

      it {
        should contain_file('nsswitch_config_file').with_content(/^printers:   user files$/)
        should contain_file('nsswitch_config_file').with_content(/^ipnodes:    files dns$/)
        should contain_file('nsswitch_config_file').with_content(/^auth_attr:  files$/)
        should contain_file('nsswitch_config_file').with_content(/^prof_attr:  files$/)
        should contain_file('nsswitch_config_file').with_content(/^project:    files$/)
      }
    end

    context 'with default options on osfamily RedHat' do
      let :facts do
      {
        :osfamily => 'RedHat',
      }
      end

      it {
        should_not contain_file('nsswitch_config_file').with_content(/^printers:   user files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^ipnodes:    files dns$/)
        should_not contain_file('nsswitch_config_file').with_content(/^auth_attr:  files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^prof_attr:  files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^project:    files$/)
      }
    end

    context 'with default options on osfamily Suse' do
      let :facts do
      {
        :osfamily => 'Suse',
      }
      end

      it {
        should_not contain_file('nsswitch_config_file').with_content(/^printers:   user files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^ipnodes:    files dns$/)
        should_not contain_file('nsswitch_config_file').with_content(/^auth_attr:  files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^prof_attr:  files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^project:    files$/)
      }
    end

    context 'with default options on osfamily Debian' do
      let :facts do
      {
        :osfamily => 'Debian',
      }
      end

      it {
        should_not contain_file('nsswitch_config_file').with_content(/^printers:   user files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^ipnodes:    files dns$/)
        should_not contain_file('nsswitch_config_file').with_content(/^auth_attr:  files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^prof_attr:  files$/)
        should_not contain_file('nsswitch_config_file').with_content(/^project:    files$/)
      }
    end

    context 'with config_file set to invalid value' do
      let :params do
        { :config_file => 'not/an/absolute/path' }
      end

      it do
        expect {
          should contain_class('nsswitch')
        }.to raise_error(Puppet::Error)
      end
    end
  end
end
