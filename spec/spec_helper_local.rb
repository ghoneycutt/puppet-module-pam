RSpec.configure do |config|
  # Use facterdb facts for facter 3.x rather than
  # facterdb for detected facter gem version which would be 2.x
  config.default_facter_version = '3.11.9'
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
