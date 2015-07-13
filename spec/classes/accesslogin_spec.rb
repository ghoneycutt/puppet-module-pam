require 'spec_helper'
describe 'pam::accesslogin' do
  describe 'access.conf' do
    context 'with default values on supported platform' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      it { should contain_class('pam') }

      it {
        should contain_file('access_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/access.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }

      it {
        should contain_file('access_conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#

# deny any users listed here

# allow only the groups listed
+ : root : ALL

# default deny
- : ALL : ALL
})
      }
    end

    context 'with multiple allowed users on supported platform expressed as an array' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => ["foo","bar"] }'
      end

      it { should contain_class('pam') }

      it {
        should contain_file('access_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/access.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }

      it {
        should contain_file('access_conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#

# deny any users listed here

# allow only the groups listed
+ : foo : ALL
+ : bar : ALL

# default deny
- : ALL : ALL
})
      }
    end

    context 'with multiple denied users on supported platform expressed as an array' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": denied_users => ["foo","bar"] }'
      end

      it { should contain_class('pam') }

      it {
        should contain_file('access_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/access.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }

      it {
        should contain_file('access_conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#

# deny any users listed here
- : foo : ALL
- : bar : ALL

# allow only the groups listed
+ : root : ALL

# default deny
- : ALL : ALL
})
      }
    end

context 'with multiple allowed and denied users on supported platform expressed as an array' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => ["foo","bar"], 
	                 denied_users => ["baz","qux"] }'
      end

      it { should contain_class('pam') }

      it {
        should contain_file('access_conf').with({
          'ensure'  => 'file',
          'path'    => '/etc/security/access.conf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }

      it {
        should contain_file('access_conf').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
#

# deny any users listed here
- : baz : ALL
- : qux : ALL

# allow only the groups listed
+ : foo : ALL
+ : bar : ALL

# default deny
- : ALL : ALL
})
      }
    end

    context 'with hash entry for allowed users containing string values for origin' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username1" => "cron", "username2" => "tty0"} }'
      end
      it { should contain_file('access_conf').with_content(/^\+ : username1 : cron$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username2 : tty0$/)}
    end

    context 'with hash entry for denied users containing string values for origin' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": denied_users => {"username1" => "cron", "username2" => "tty0"} }'
      end
      it { should contain_file('access_conf').with_content(/^\- : username1 : cron$/)}
      it { should contain_file('access_conf').with_content(/^\- : username2 : tty0$/)}
      it { should contain_file('access_conf').with_content(/^\+ : root : ALL$/)}
    end

    context 'with hash entry for both allowed and denied users containing string values for origin' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username1" => "cron", "username2" => "tty0"}, 
		         denied_users => {"username3" => "tty1", "username4" => "tty2"} }'
      end
      it { should contain_file('access_conf').with_content(/^\- : username3 : tty1$/)}
      it { should contain_file('access_conf').with_content(/^\- : username4 : tty2$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username1 : cron$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username2 : tty0$/)}
    end

    context 'with hash entry for allowed users containing array of values for origin' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username" => ["cron", "tty0"]} }'
      end
      it { should contain_file('access_conf').with_content(/^\+ : username : cron tty0$/)}
    end

    context 'with hash entry for denied users containing array of values for origin' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": denied_users => {"username" => ["cron", "tty0"]} }'
      end
      it { should contain_file('access_conf').with_content(/^\- : username : cron tty0$/)}
      it { should contain_file('access_conf').with_content(/^\+ : root : ALL$/)}
    end

    context 'with hash entry for both allowed and denied users containing array of values for origin' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username1" => ["cron", "tty0"]},
                         denied_users => {"username2" => ["tty1", "tty2"]} }'

      end
      it { should contain_file('access_conf').with_content(/^\- : username2 : tty1 tty2$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username1 : cron tty0$/)}
    end

    context 'with hash entry for allowed users containing no value for origin should default to "ALL"' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username" => {} }}'
      end
      it { should contain_file('access_conf').with_content(/^\+ : username : ALL$/)}
    end

    context 'with hash entry for denied users containing no value for origin should default to "ALL"' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": denied_users => {"username" => {} }}'
      end
      it { should contain_file('access_conf').with_content(/^\- : username : ALL$/)}
      it { should contain_file('access_conf').with_content(/^\+ : root : ALL$/)}
    end

    context 'with hash entry for both allowed and denied users containing no value for origin should default to "ALL"' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username1" => {} },
                         denied_users => {"username2" => {} } }'
      end
      it { should contain_file('access_conf').with_content(/^\- : username2 : ALL$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username1 : ALL$/)}
    end

    context 'with hash entries for allowed users containing string, array and empty hash' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username" => "tty5", "username1" => ["cron", "tty0"], "username2" => "cron", "username3" => "tty0", "username4" => {}}}'
      end
      it { should contain_file('access_conf').with_content(/^\+ : username : tty5$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username1 : cron tty0$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username2 : cron$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username3 : tty0$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username4 : ALL$/)}
    end

    context 'with hash entries for denied users containing string, array and empty hash' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": denied_users => {"username" => "tty5", "username1" => ["cron", "tty0"], "username2" => "cron", "username3" => "tty0", "username4" => {}}}'
      end
      it { should contain_file('access_conf').with_content(/^\- : username : tty5$/)}
      it { should contain_file('access_conf').with_content(/^\- : username1 : cron tty0$/)}
      it { should contain_file('access_conf').with_content(/^\- : username2 : cron$/)}
      it { should contain_file('access_conf').with_content(/^\- : username3 : tty0$/)}
      it { should contain_file('access_conf').with_content(/^\- : username4 : ALL$/)}
      it { should contain_file('access_conf').with_content(/^\+ : root : ALL$/)}
    end

    context 'with hash entries for both allowed and denied users containing string, array and empty hash' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end
      let(:pre_condition) do
          'class {"pam": allowed_users => {"username" => "tty5", "username1" => ["cron", "tty0"], "username2" => "cron", "username3" => "tty0", "username4" => {}},
	                 denied_users => {"username5" => "tty5", "username6" => ["cron", "tty0"], "username7" => "cron", "username8" => "tty0", "username9" => {}}}'
      end
      it { should contain_file('access_conf').with_content(/^\- : username5 : tty5$/)}
      it { should contain_file('access_conf').with_content(/^\- : username6 : cron tty0$/)}
      it { should contain_file('access_conf').with_content(/^\- : username7 : cron$/)}
      it { should contain_file('access_conf').with_content(/^\- : username8 : tty0$/)}
      it { should contain_file('access_conf').with_content(/^\- : username9 : ALL$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username : tty5$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username1 : cron tty0$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username2 : cron$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username3 : tty0$/)}
      it { should contain_file('access_conf').with_content(/^\+ : username4 : ALL$/)}
    end

    context 'with custom values on supported platform' do
      let(:facts) do
        {
          :osfamily                   => 'RedHat',
          :operatingsystemmajrelease  => '5',
        }
      end

      let(:params) do
        {
          :access_conf_path     => '/custom/security/access.conf',
          :access_conf_owner    => 'guido',
          :access_conf_group    => 'guido',
          :access_conf_mode     => '0777',
        }
      end

      it { should contain_class('pam') }

      it {
        should contain_file('access_conf').with({
          'ensure'  => 'file',
          'path'    => '/custom/security/access.conf',
          'owner'   => 'guido',
          'group'   => 'guido',
          'mode'    => '0777',
          'require' => [ 'Package[pam]', 'Package[util-linux]' ],
        })
      }
    end
  end
end
