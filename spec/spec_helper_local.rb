RSpec.configure do |config|
  # Use facterdb facts for facter 3.x rather than
  # facterdb for detected facter gem version which would be 2.x
  config.default_facter_version = '3.11.9'
end

def platforms
  {
    'el5' =>
      {
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
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'debian10' =>
      {
        pam_d_login: 'without_pam_access',
        pam_d_sshd: 'with_pam_access',
        packages: [ 'libpam0g' ],
        files: [
          { prefix: 'pam_common_',
            types: ['auth', 'account', 'password', 'session', 'session_noninteractive' ], },
        ],
      },
    'debian11' =>
      {
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
