RSpec.configure do |config|
  # Use facterdb facts for facter 3.x rather than
  # facterdb for detected facter gem version which would be 2.x
  config.default_facter_version = '3.11.9'
end

def platforms
  {
    'el5' =>
      {
        facts_hash: {
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemmajrelease: '5',
          os: {
            'name' => 'RedHat',
            'family' => 'RedHat',
            'release' => {
              'full'  => '5.10',
              'major' => '5',
              'minor' => '10'
            },
          },
        },
        pam_d_login: 'with_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: ['pam', 'util-linux' ],
        files: [
          { prefix: 'pam_system_',
            types: ['auth' ],
            suffix: '_ac',
            symlink: true, },
        ],
      },
    'el6' =>
      {
        facts_hash: {
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemmajrelease: '6',
          os: {
            'name' => 'RedHat',
            'family' => 'RedHat',
            'release' => {
              'full'  => '6.5',
              'major' => '6',
              'minor' => '5'
            }
          },
        },
        pam_d_login: 'with_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: ['pam' ],
        files: [
          { prefix: 'pam_',
            types: ['system_auth', 'password_auth' ],
            suffix: '_ac',
            symlink: true, },
        ],
      },
    'el7' =>
      {
        facts_hash: {
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemmajrelease: '7',
          os: {
            'name' => 'RedHat',
            'family' => 'RedHat',
            'release' => {
              'full'  => '7.0.1406',
              'major' => '7',
              'minor' => '0'
            }
          },
        },
        pam_d_login: 'with_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: ['pam' ],
        files: [
          { prefix: 'pam_',
            types: ['system_auth' ],
            suffix: '_ac',
            symlink: true, },
        ],
      },
    'el8' =>
      {
        facts_hash: {
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemmajrelease: '8',
          os: {
            'name' => 'RedHat',
            'family' => 'RedHat',
            'release' => {
              'full'  => '8.0',
              'major' => '8',
              'minor' => '0'
            }
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'without_pam_access',
        packages: ['pam' ],
        files: [
          { prefix: 'pam_',
            types: ['system_auth' ],
            suffix: '_ac',
            symlink: true, },
        ],
      },
    'suse9' =>
      {
        facts_hash: {
          osfamily: 'Suse',
          operatingsystem: 'SLES',
          operatingsystemmajrelease: '9',
          os: {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '9.1',
              'major' => '9',
              'minor' => '1'
            }
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'without_pam_access',
        packages: ['pam', 'pam-modules' ],
        files: [
          { prefix: 'pam_',
            types: ['other' ], },
        ],
      },
    'suse10' =>
      {
        facts_hash: {
          osfamily: 'Suse',
          operatingsystem: 'SLES',
          operatingsystemmajrelease: '10',
          os: {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '10.1',
              'major' => '10',
              'minor' => '1'
            }
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'without_pam_access',
        packages: ['pam' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session' ], },
        ],
      },
    'suse11' =>
      {
        facts_hash: {
          osfamily: 'Suse',
          operatingsystem: 'SLES',
          operatingsystemmajrelease: '11',
          os: {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '11.1',
              'major' => '11',
              'minor' => '1'
            }
          },
        },
        pam_d_login: 'with_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: ['pam' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session' ],
            suffix: '_pc',
            symlink: true, },
        ],
      },
    'suse12' =>
      {
        facts_hash: {
          osfamily: 'Suse',
          operatingsystem: 'SLES',
          operatingsystemmajrelease: '12',
          os: {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '12.1',
              'major' => '12',
              'minor' => '1'
            }
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'without_pam_access',
        packages: ['pam' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session' ],
            suffix: '_pc',
            symlink: true, },
        ],
      },
    'suse13' =>
      {
        facts_hash: {
          osfamily: 'Suse',
          operatingsystem: 'SLES',
          operatingsystemmajrelease: '13',
          os: {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '13.1',
              'major' => '13',
              'minor' => '1'
            }
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'without_pam_access',
        packages: ['pam' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session' ],
            suffix: '_pc',
            symlink: true, },
        ],
      },
    'suse15' =>
      {
        facts_hash: {
          osfamily: 'Suse',
          operatingsystem: 'SLES',
          operatingsystemmajrelease: '15',
          os: {
            'name' => 'openSUSE',
            'family' => 'Suse',
            'release' => {
              'full'  => '15.0',
              'major' => '15',
              'minor' => '0'
            }
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'without_pam_access',
        packages: ['pam' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session' ],
            suffix: '_pc',
            symlink: true, },
        ],
      },
    'solaris9' =>
      {
        facts_hash: {
          osfamily: 'Solaris',
          operatingsystem: 'Solaris',
          kernelrelease: '5.9',
          os: {
            'name' => 'Solaris',
            'family' => 'Solaris',
            'release' => {
              'full'  => '5.9',
              'major' => '5',
              'minor' => '9'
            }
          },
        },
        pam_d_login: 'not_present',
        pam_d_sshd: 'not_present',
        packages: [],
        files: [
          { prefix: 'pam_',
            types: ['conf' ],
            group: 'sys',
            dirpath: '/etc/pam.', },
        ],
      },
    'solaris10' =>
      {
        facts_hash: {
          osfamily: 'Solaris',
          operatingsystem: 'Solaris',
          kernelrelease: '5.10',
          os: {
            'name' => 'Solaris',
            'family' => 'Solaris',
            'release' => {
              'full'  => '5.10',
              'major' => '5',
              'minor' => '10'
            }
          },
        },
        pam_d_login: 'not_present',
        pam_d_sshd: 'not_present',
        packages: [],
        files: [
          { prefix: 'pam_',
            types: ['conf' ],
            group: 'sys',
            dirpath: '/etc/pam.', },
        ],
      },
    'solaris11' =>
      {
        facts_hash: {
          osfamily: 'Solaris',
          operatingsystem: 'Solaris',
          kernelrelease: '5.11',
          os: {
            'name' => 'Solaris',
            'family' => 'Solaris',
            'release' => {
              'full'  => '5.11',
              'major' => '5',
              'minor' => '11'
            },
          },
        },
        pam_d_login: 'not_present',
        pam_d_sshd: 'not_present',
        packages: [],
        files: [
          { prefix: 'pam_',
            types: ['other' ],
            group: 'sys', },
        ],
      },
    'ubuntu1204' =>
      {
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          os: {
            'release' => {
              'full'  => '12.04',
              'major' => '12.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'ubuntu1404' =>
      {
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          os: {
            'release' => {
              'full'  => '14.04',
              'major' => '14.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'ubuntu1604' =>
      {
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          os: {
            'release' => {
              'full'  => '16.04',
              'major' => '16.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'ubuntu1804' =>
      {
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          os: {
            'release' => {
              'full'  => '18.04',
              'major' => '18.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'ubuntu2004' =>
      {
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          os: {
            'release' => {
              'full'  => '20.04',
              'major' => '20.04'
            },
            'name'   => 'Ubuntu',
            'family' => 'Debian'
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'debian7' =>
      {
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Debian',
          os: {
            'name' => 'Debian',
            'family' => 'Debian',
            'release' => {
              'full'  => '7.8',
              'major' => '7',
              'minor' => '8'
            },
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'debian8' =>
      {
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Debian',
          os: {
            'name' => 'Debian',
            'family' => 'Debian',
            'release' => {
              'full'  => '8.0',
              'major' => '8',
              'minor' => '0'
            },
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'debian9' =>
      {
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Debian',
          os: {
            'name' => 'Debian',
            'family' => 'Debian',
            'release' => {
              'full'  => '9.0',
              'major' => '9',
              'minor' => '0'
            },
          },
        },
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      }
  }
end

def unsupported_platforms
  {
    'el4' =>
      {
        facts_hash: {
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemmajrelease: '4',
          os: {
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
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Debian',
          os: {
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
        facts_hash: {
          osfamily: 'Suse',
          operatingsystem: 'SLES',
          operatingsystemmajrelease: '8',
          os: {
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
        facts_hash: {
          osfamily: 'Debian',
          operatingsystem: 'Ubuntu',
          os: {
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
        facts_hash: {
          osfamily: 'Solaris',
          operatingsystem: 'Solaris',
          kernelrelease: '5.8',
          os: {
            'family' => 'Solaris',
          },
        }
      },
  }
end
