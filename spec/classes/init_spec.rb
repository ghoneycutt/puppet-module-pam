require 'spec_helper'
describe 'nsswitch' do

  describe 'with default values for all parameters' do
    context 'on an unsupported osfamily' do
      let(:facts) { { :osfamily => 'unsupported' } }

      it do
        expect {
          should contain_class('nsswitch')
        }.to raise_error(Puppet::Error)
      end
    end

    context 'on osfamily Solaris' do
      let(:facts) { { :osfamily => 'Solaris' } }

      it { should contain_class('nsswitch') }

      it {
        should contain_file('nsswitch_config_file').with({
          'ensure'  => 'file',
          'path'    => '/etc/nsswitch.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it {
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
ipnodes:    files dns
printers:   user files
auth_attr:  files
prof_attr:  files
project:    files
})
      }
    end

    ['RedHat','Suse','Debian'].each do |platform|
      context "on osfamily #{platform}" do
        if platform = 'RedHat'
          let(:facts) do
            {
              :osfamily                  => platform,
              :operatingsystemmajrelease => '6',
            }
          end
        else
          let(:facts) { { :osfamily => platform } }
        end

        it { should contain_class('nsswitch') }

        it {
          should contain_file('nsswitch_config_file').with({
            'ensure'  => 'file',
            'path'    => '/etc/nsswitch.conf',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
          })
        }

        it {
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
    end

    context 'on RedHat 7' do
      let(:facts) do
        { :osfamily                  => 'RedHat',
          :operatingsystemmajrelease => '7',
        }
      end

      it { should contain_class('nsswitch') }

      it {
        should contain_file('nsswitch_config_file').with({
          'ensure'  => 'file',
          'path'    => '/etc/nsswitch.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      }

      it {
        should contain_file('nsswitch_config_file').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT

passwd:     files sss
shadow:     files sss
group:      files sss

sudoers:    files sss

hosts:      files dns myhostname

bootparams: nisplus [NOTFOUND=return] files
ethers:     files
netmasks:   files
networks:   files
protocols:  files
rpc:        files
services:   files sss
netgroup:   files sss
publickey:  nisplus
automount:  files sss
aliases:    files nisplus
})
      }
    end
  end

  context 'with ldap enabled' do
    let :params do
      { :ensure_ldap => 'present' }
    end
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
    let :facts do
      { :osfamily => 'Debian' }
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
