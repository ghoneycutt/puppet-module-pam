# This RSpec.configure block is listed twice due to a bug with
# puppetlabs_spec_helper. https://tickets.puppetlabs.com/browse/PDK-916
RSpec.configure do |config|
  config.mock_with :rspec
end
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |config|
  #config.hiera_config = 'spec/hiera.yaml'
  config.before :each do
    # Ensure that we don't accidentally cache facts and environment between
    # test cases.  This requires each example group to explicitly load the
    # facts being exercised with something like
    # Facter.collection.loader.load(:ipaddress)
    Facter.clear
    Facter.clear_messages
  end
  config.default_facts = {
    :environment => 'rp_env',
  }
end

def platforms
  {
    'el5' =>
      {
        :facts_hash => {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemmajrelease => '5',
          :os => {
            'name' => 'RedHat',
            'family' => 'RedHat',
            'release' => {
              'full'  => '5.10',
              'major' => '5',
              'minor' => '10'
            },
          },
        },
        :packages           => ['pam', 'util-linux', ],
        :files              => [
          { :prefix         => 'pam_system_',
            :types          => ['auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'el6' =>
      {
        :facts_hash => {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemmajrelease => '6',
          :os => {
            'name' => 'RedHat',
            'family' => 'RedHat',
            'release' => {
              'full'  => '6.5',
              'major' => '6',
              'minor' => '5'
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['system_auth', 'password_auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'el7' =>
      {
        :facts_hash => {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemmajrelease => '7',
          :os => {
            'name' => 'RedHat',
            'family' => 'RedHat',
            'release' => {
              'full'  => '7.0.1406',
              'major' => '7',
              'minor' => '0'
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['system_auth', ],
            :suffix         => '_ac',
            :symlink        => true,
          }, ],
      },
    'suse9' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystem => 'SLES',
          :operatingsystemmajrelease => '9',
          :os => {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '9.1',
              'major' => '9',
              'minor' => '1'
            }
          },
        },
        :packages           => ['pam', 'pam-modules', ],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['other', ],
          }, ],
      },
    'suse10' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystem => 'SLES',
          :operatingsystemmajrelease => '10',
          :os => {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '10.1',
              'major' => '10',
              'minor' => '1'
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
          }, ],
      },
    'suse11' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystem => 'SLES',
          :operatingsystemmajrelease => '11',
          :os => {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '11.1',
              'major' => '11',
              'minor' => '1'
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'suse12' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystem => 'SLES',
          :operatingsystemmajrelease => '12',
          :os => {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '12.1',
              'major' => '12',
              'minor' => '1'
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'suse13' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystem => 'SLES',
          :operatingsystemmajrelease => '13',
          :os => {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '13.1',
              'major' => '13',
              'minor' => '1'
            }
          },
        },
        :packages           => ['pam', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', ],
            :suffix         => '_pc',
            :symlink        => true,
          }, ],
      },
    'solaris9' =>
      {
        :facts_hash => {
          :osfamily => 'Solaris',
          :operatingsystem => 'Solaris',
          :kernelrelease => '5.9',
          :os => {
            'name' => 'Solaris',
            'family' => 'Solaris',
            'release' => {
              'full'  => '5.9',
              'major' => '5',
              'minor' => '9'
            }
          },
        },
        :packages           => [],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['conf', ],
            :group          => 'sys',
            :dirpath        => '/etc/pam.',
          }, ],
      },
    'solaris10' =>
      {
        :facts_hash => {
          :osfamily => 'Solaris',
          :operatingsystem => 'Solaris',
          :kernelrelease => '5.10',
          :os => {
            'name' => 'Solaris',
            'family' => 'Solaris',
            'release' => {
              'full'  => '5.10',
              'major' => '5',
              'minor' => '10'
            }
          },
        },
        :packages           => [],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['conf', ],
            :group          => 'sys',
            :dirpath        => '/etc/pam.',
          }, ],
      },
    'solaris11' =>
      {
        :facts_hash => {
          :osfamily => 'Solaris',
          :operatingsystem => 'Solaris',
          :kernelrelease => '5.11',
          :os => {
            'name' => 'Solaris',
            'family' => 'Solaris',
            'release' => {
              'full'  => '5.11',
              'major' => '5',
              'minor' => '11'
            },
          },
        },
        :packages           => [],
        :files              => [
          { :prefix         => 'pam_',
            :types          => ['other', ],
            :group          => 'sys',
          }, ],
      },
    'ubuntu1204' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :operatingsystem => 'Ubuntu',
          :os => {
            'release' => {
              'full'  => '12.04',
              'major' => '12.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'session_noninteractive' ],
          }, ],
      },
    'ubuntu1404' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :operatingsystem => 'Ubuntu',
          :os => {
            'release' => {
              'full'  => '14.04',
              'major' => '14.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'session_noninteractive' ],
          }, ],
      },
    'ubuntu1604' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :operatingsystem => 'Ubuntu',
          :os => {
            'release' => {
              'full'  => '16.04',
              'major' => '16.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'session_noninteractive' ],
          }, ],
      },
    'ubuntu1804' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :operatingsystem => 'Ubuntu',
          :os => {
            'release' => {
              'full'  => '18.04',
              'major' => '18.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'session_noninteractive' ],
          }, ],
      },
    'debian7' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :operatingsystem => 'Debian',
          :os => {
            'name' => 'Debian',
            'family' => 'Debian',
            'release' => {
              'full'  => '7.8',
              'major' => '7',
              'minor' => '8'
            },
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'session_noninteractive' ],
          }, ],
      },
    'debian8' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :operatingsystem => 'Debian',
          :os => {
            'name' => 'Debian',
            'family' => 'Debian',
            'release' => {
              'full'  => '8.0',
              'major' => '8',
              'minor' => '0'
            },
          },
        },
        :packages           => [ 'libpam0g', ],
        :files              => [
          { :prefix         => 'pam_common_',
            :types          => ['auth', 'account', 'password', 'session', 'session_noninteractive' ],
          }, ],
      }
  }
end

def unsupported_platforms
  {
    'el4' =>
      {
        :facts_hash => {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemmajrelease => '4',
          :os => {
            'name' => 'RedHat',
            'family' => 'RedHat',
            'release' => {
              'full'  => '4.10',
              'major' => '4',
              'minor' => '10'
            },
          },
        }
      },
    'debian6' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :operatingsystem => 'Debian',
          :os => {
            'name' => 'Debian',
            'family' => 'Debian',
            'release' => {
              'full'  => '6.8',
              'major' => '6',
              'minor' => '8'
            },
          },
        }
      },
    'suse8' =>
      {
        :facts_hash => {
          :osfamily => 'Suse',
          :operatingsystem => 'SLES',
          :operatingsystemmajrelease => '8',
          :os => {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '8.1',
              'major' => '8',
              'minor' => '1'
            }
          },
        }
      },
    'ubuntu1004' =>
      {
        :facts_hash => {
          :osfamily => 'Debian',
          :operatingsystem => 'Ubuntu',
          :os => {
            'release' => {
              'full'  => '10.04',
              'major' => '10.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        }
      },
    'solaris8' =>
      {
        :facts_hash => {
          :osfamily => 'Solaris',
          :operatingsystem => 'Solaris',
          :kernelrelease => '5.8',
        }
      },
  }
end
