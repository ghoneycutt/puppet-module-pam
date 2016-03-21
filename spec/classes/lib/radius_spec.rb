require 'spec_helper'
describe 'pam::lib::radius' do

  platforms = {
    'debian6' =>
      { :osfamily     => 'Debian',
        :release      => '6',
        :lsbdistid    => '',
        :package_name => 'libpam-radius-auth',
      },
    'el5' =>
      { :osfamily     => 'RedHat',
        :release      => '5',
        :lsbdistid    => '',
        :package_name => 'pam_radius',
      },
    'el6' =>
      { :osfamily     => 'RedHat',
        :release      => '6',
        :lsbdistid    => '',
        :package_name => 'pam_radius',
      },
    'el7' =>
      { :osfamily     => 'RedHat',
        :release      => '7',
        :lsbdistid    => '',
        :package_name => 'pam_radius',
      },
    'solaris10' =>
      { :osfamily     => 'Solaris',
        :release      => '5.10',
        :lsbdistid    => '',
        :package_name => '',
      },
    'solaris11' =>
      { :osfamily     => 'Solaris',
        :release      => '5.11',
        :lsbdistid    => '',
        :package_name => '',
      },
    'suse9' =>
      { :osfamily     => 'Suse',
        :release      => '9',
        :lsbdistid    => '',
        :package_name => 'pam_radius',
      },
    'suse10' =>
      { :osfamily     => 'Suse',
        :release      => '10',
        :lsbdistid    => '',
        :package_name => 'pam_radius',
      },
    'suse11' =>
      { :osfamily     => 'Suse',
        :release      => '11',
        :lsbdistid    => '',
        :package_name => 'pam_radius',
      },
    'suse12' =>
      { :osfamily     => 'Suse',
        :release      => '12',
        :lsbdistid    => '',
        :package_name => 'pam_radius',
      },
    'ubuntu1204' =>
      { :osfamily     => 'Debian',
        :release      => '12',
        :lsbdistid    => 'Ubuntu',
        :package_name => 'libpam-radius-auth',
      },
    'ubuntu1404' =>
      { :osfamily     => 'Debian',
        :release      => '14',
        :lsbdistid    => 'Ubuntu',
        :package_name => 'libpam-radius-auth',
      },
  }

  describe 'with default values for parameters on' do
    platforms.sort.each do |k,v|
      context "#{k}" do
        if v[:osfamily] == 'Solaris'
          let :facts do
            { :osfamily      => v[:osfamily],
              :kernelrelease => v[:release],
            }
          end
        else
          let :facts do
            { :osfamily                  => v[:osfamily],
              :lsbmajdistrelease         => v[:release],
              :lsbdistid                 => v[:lsbdistid],
              :lsbdistrelease            => "#{v[:release]}.04",
              :operatingsystemmajrelease => v[:release],
            }
          end
        end

        if v[:osfamily] == 'Solaris'
          it 'should fail' do
            expect {
              should contain_class('pam::lib::radius')
            }.to raise_error(Puppet::Error,
              /pam::lib::radius does not have a default for your system. Please specify a package at pam::lib::radius::package_name./)
          end
        else
          it { should contain_class('pam::lib::radius') }

          it {
            should contain_package('pam_lib_radius').with({
              'ensure' => 'installed',
              'name'   => v[:package_name],
            })
          }
        end
      end
    end
  end

  params = {
    'package_ensure' =>
      { :value => 'installed',
        :type  => 'string',
      },
    'package_name' =>
      { :value => 'USE_DEFAULTS',
        :type  => 'string',
      },
  }

  describe 'with an invalid value for parameter' do
    params.sort.each do |k,v|
      context "#{k}" do
        let :facts do
          { :osfamily                  => 'RedHat',
            :operatingsystemmajrelease => '7',
          }
        end

        case v[:type]
        when 'array'
          kvalue = 'invalid_type'
          errormsg = '"invalid_type" is not an array.  It looks to be a String.'
        when 'string'
          kvalue = ['invalid','type']
          errormsg = '\["invalid", "type"\] is not a string.  It looks to be a Array'
        when 'path'
          kvalue = 'invalid/path'
          errormsg = '"invalid/path" is not an absolute path.'
        when 'bool'
          kvalue = ['invalid','type']
          errormsg = '\["invalid", "type"\] is not a boolean.  It looks to be a Array'
        when 'hash'
          kvalue = ['invalid','type']
          errormsg = '\["invalid", "type"\] is not a hash.  It looks to be a Array'
        else
          raise "error in your spec tests - you have an unknown type value (#{v[:type]}) for parameter #{k}."
        end

        let(:params) { { :"#{k}" => kvalue } }

        it 'should fail' do
          expect {
            should contain_class('pam::lib::radius')
          }.to raise_error(Puppet::Error,/#{errormsg}/)
        end
      end
    end
  end

  describe 'with a valid custom value specified for parameter' do
    let :facts do
      { :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
      }
    end

    context 'package_ensure' do
      let(:params) { { :package_ensure => 'absent' } }

      it {
        should contain_package('pam_lib_radius').with({
          'ensure' => 'absent',
        })
      }
    end

    context 'package_name' do
      let(:params) { { :package_name => 'my_radius_pkg' } }

      it {
        should contain_package('pam_lib_radius').with({
          'name' => 'my_radius_pkg',
        })
      }
    end
  end
end
