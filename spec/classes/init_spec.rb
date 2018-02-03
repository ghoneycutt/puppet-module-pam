require 'spec_helper'
describe 'pam' do
  let(:facts) { platforms['el7'][:facts_hash] }

  file_header = <<-END.gsub(/^\s+\|/, '')
    |# This file is being maintained by Puppet.
    |# DO NOT EDIT
  END

  context 'with default values on supported platform EL7' do
    it { should compile.with_all_deps }

    it { should contain_class('pam') }
    it { should contain_class('pam::accesslogin') }
    it { should contain_class('pam::limits') }
    it { should have_package_resource_count(1) }
    it { should contain_package('pam').with_ensure('installed') }

    it do
      should contain_file('pam_d_login').with({
        'ensure'  => 'file',
        'path'    => '/etc/pam.d/login',
        'content' => File.read(fixtures('pam_d_login.defaults.el7')),
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })
    end

    it do
      should contain_file('pam_d_sshd').with({
        'ensure'  => 'file',
        'path'    => '/etc/pam.d/sshd',
        'content' => File.read(fixtures('pam_d_sshd.defaults.el7')),
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })
    end

    it { should contain_class('nsswitch') }
    it { should have_pam__service_resource_count(0) }
    it { should have_pam__limits__fragment_resource_count(0) }

    it do
      should contain_file('pam_password_auth_ac').with({
        'ensure'  => 'file',
        'path'    => '/etc/pam.d/password-auth-ac',
        'content' => File.read(fixtures('pam_password_auth_ac.defaults.el7')),
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => [ 'Package[pam]' ],
      })
    end

    it do
      should contain_file('pam_password_auth').with({
        'ensure'  => 'link',
        'path'    => '/etc/pam.d/password-auth',
        'target'  => '/etc/pam.d/password-auth-ac',
        'owner'   => 'root',
        'group'   => 'root',
        'require' => [ 'Package[pam]' ],
      })
    end
  end

  describe 'on unsupported platforms' do
    unsupported_platforms.sort.each do |k,v|
      context "with defaults params on #{k}" do
        let(:facts) { v[:facts_hash] }

        it 'should fail' do
          expect {
            should contain_class('pam')
          }.to raise_error(Puppet::Error)
        end
      end
    end
  end

  # plattform independent parameters
  context 'with services set to a valid hash' do
    let(:params) { { :services => { 'testservice' => { 'content' => 'foo' } } } }
    it { should have_pam__service_resource_count(1) }
    it { should contain_pam__service('testservice').with_content('foo') }
  end

  context 'with limits_fragments set to a valid hash' do
    let(:params) { {:limits_fragments => { 'test_limit' => { 'list' => [ 'test' ] } }   } }
    it { should have_pam__limits__fragment_resource_count(1) }
    it { should contain_pam__limits__fragment('test_limit').with_list(%w(test)) }
  end

  context 'with pam_d_login_path set to a valid absolute path' do
    let(:params) { {:pam_d_login_path => '/etc/pam.d/testing' } }
    it { should contain_file('pam_d_login').with_path('/etc/pam.d/testing') }
  end

  context 'with pam_d_login_owner set to a valid string' do
    let(:params) { {:pam_d_login_owner => 'tester' } }
    it { should contain_file('pam_d_login').with_owner('tester') }
  end

  context 'with pam_d_login_group set to a valid string' do
    let(:params) { {:pam_d_login_group => 'tester' } }
    it { should contain_file('pam_d_login').with_group('tester') }
  end

  context 'with pam_d_login_mode set to a valid string' do
    let(:params) { {:pam_d_login_mode => '0242' } }
    it { should contain_file('pam_d_login').with_mode('0242') }
  end

  context 'with pam_d_login_template set to a valid string' do
    let(:params) { {:pam_d_login_template => 'pam/unit_tests.erb' } }
    it { should contain_file('pam_d_login').with_content('dummy template for unit tests only') }
  end

  context 'with pam_d_sshd_path set to a valid absolute path' do
    let(:params) { {:pam_d_sshd_path => '/etc/pam.d/testing' } }
    it { should contain_file('pam_d_sshd').with_path('/etc/pam.d/testing') }
  end

  context 'with pam_d_sshd_owner set to a valid string' do
    let(:params) { {:pam_d_sshd_owner => 'tester' } }
    it { should contain_file('pam_d_sshd').with_owner('tester') }
  end

  context 'with pam_d_sshd_group set to a valid string' do
    let(:params) { {:pam_d_sshd_group => 'tester' } }
    it { should contain_file('pam_d_sshd').with_group('tester') }
  end

  context 'with pam_d_sshd_mode set to a valid string' do
    let(:params) { {:pam_d_sshd_mode => '0242' } }
    it { should contain_file('pam_d_sshd').with_mode('0242') }
  end

  context 'with pam_d_sshd_template set to a valid string' do
    let(:params) { {:pam_d_sshd_template => 'pam/unit_tests.erb' } }
    it { should contain_file('pam_d_sshd').with_content('dummy template for unit tests only') }
  end

  context 'with pam_d_sshd_template set to pam/sshd.custom.erb when all pam_sshd_*_lines parameters are set to valid arrays' do
    let (:params) do
      {
        :pam_d_sshd_template => 'pam/sshd.custom.erb',
        :pam_sshd_auth_lines     => %w(auth_line1 auth_line2),
        :pam_sshd_account_lines  => %w(account_line1 account_line2),
        :pam_sshd_password_lines => %w(password_line1 password_line2),
        :pam_sshd_session_lines  => %w(session_line1 session_line2),
      }
    end
    file_content = <<-END.gsub(/^\s+\|/, '')
      |#
      |auth_line1
      |auth_line2
      |account_line1
      |account_line2
      |password_line1
      |password_line2
      |session_line1
      |session_line2
    END
    it { should contain_file('pam_d_sshd').with_content(file_header + file_content) }
  end

  [:pam_sshd_auth_lines, :pam_sshd_account_lines, :pam_sshd_password_lines, :pam_sshd_session_lines].each do |param|
    context "with pam_d_sshd_template set to pam/sshd.custom.erb when only #{param} is missing" do
      let :full_params do
        {
          :pam_sshd_auth_lines     => %w(auth_line1 auth_line2),
          :pam_sshd_account_lines  => %w(account_line1 account_line2),
          :pam_sshd_session_lines  => %w(session_line1 session_line2),
          :pam_sshd_password_lines => %w(password_line1 password_line2),
          :pam_d_sshd_template     => 'pam/sshd.custom.erb',
        }
      end
      let(:params) {
        # remove param from full_params hash before applying
        full_params.delete(param)
        full_params
      }

      it 'should fail' do
        expect { should contain_class(subject) }.to raise_error(Puppet::Error, %r{pam_sshd_\[auth\|account\|password\|session\]_lines required when using the pam/sshd.custom.erb template})
      end
    end
  end

  [ :pam_sshd_auth_lines, :pam_sshd_account_lines, :pam_sshd_password_lines, :pam_sshd_session_lines ].each do |param|
    context "with #{param} specified and pam_d_sshd_template not specified" do
      let(:params) { { param => [ '#' ] } }

      it "should fail" do
        expect {
          should contain_class('pam')
        }.to raise_error(Puppet::Error, %r{pam_sshd_\[auth\|account\|password\|session\]_lines are only valid when pam_d_sshd_template is configured with the pam/sshd.custom.erb template})
      end
    end
  end

  context 'with manage_nsswitch set to valid false' do
    let(:params) { {:manage_nsswitch => false } }
    it { should_not contain_class('nsswitch') }
  end

  # plattform dependent parameters
  platforms.sort.each do |os,v|
    describe "on #{os}" do
      let(:facts) { v[:facts_hash] }

      # testing platform dependent package_name and the dependencies on common_files
      context 'defaults for package_name' do
        it { should have_package_resource_count(v[:packages].count) }
        v[:packages].each do |pkg|
          it { should contain_package(pkg).with_ensure('installed') }
        end

        # OS dependent package dependencies
        v[:files].each do |file|
          group = file[:group] || 'root'
          dirpath = file[:dirpath] || '/etc/pam.d/'

          file[:types].each do |type|
            filename = "#{file[:prefix]}#{type}#{file[:suffix]}"
            path = "#{dirpath}#{file[:prefix]}#{type}#{file[:suffix]}"
            path.gsub! '_', '-'
            path.sub! 'pam-', ''
            symlinkname = "#{file[:prefix]}#{type}"
            symlinkpath = "#{dirpath}#{file[:prefix]}#{type}"
            symlinkpath.gsub! '_', '-'
            symlinkpath.sub! 'pam-', ''

            v[:packages].sort.each do |pkg|
              it { should contain_file(filename).that_requires("Package[#{pkg}]") }
              if file[:symlink]
                it { should contain_file(symlinkname).that_requires("Package[#{pkg}]") }
              end
            end
          end
        end
      end

      # testing platform dependent common_files, common_files_suffix, common_files_create_links, pam_conf_file, pam_d_login_template, pam_d_sshd_template and content for pam_*_lines
      context 'defaults for common_files' do
        v[:files].each do |file|
          group = file[:group] || 'root'
          dirpath = file[:dirpath] || '/etc/pam.d/'

          file[:types].each do |type|
            filename = "#{file[:prefix]}#{type}#{file[:suffix]}"
            path = "#{dirpath}#{file[:prefix]}#{type}#{file[:suffix]}"
            path.gsub! '_', '-'
            path.sub! 'pam-', ''

            it do
              should contain_file(filename).with({
                'ensure'  => 'file',
                'path'    => path,
                'content' => File.read(fixtures("#{filename}.defaults.#{os}")),
                'owner'   => 'root',
                'group'   => group,
                'mode'    => '0644',
              })
            end

            if file[:symlink]
              symlinkname   = "#{file[:prefix]}#{type}"
              symlinkpath   = "#{dirpath}#{file[:prefix]}#{type}"
              symlinkpath.gsub! '_', '-'
              symlinkpath.sub! 'pam-', ''

              it do
                should contain_file(symlinkname).with({
                  'ensure' => 'link',
                  'path'   => symlinkpath,
                  'target' => path,
                  'owner'  => 'root',
                  'group'  => 'root',
                })
              end
            end
          end

          if v[:facts_hash][:osfamily] != 'Solaris'
            it do
              should contain_file('pam_d_login').with({
                'ensure'  => 'file',
                'path'    => '/etc/pam.d/login',
                'content' => File.read(fixtures("pam_d_login.defaults.#{os}")),
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644',
              })
            end

            it do
              should contain_file('pam_d_sshd').with({
                'ensure'  => 'file',
                'path'    => '/etc/pam.d/sshd',
                'content' => File.read(fixtures("pam_d_sshd.defaults.#{os}")),
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644',
              })
            end
          else
            it { should_not contain_file('pam_d_login') }
            it { should_not contain_file('pam_d_sshd') }
          end
        end
      end

      context 'with login_pam_access set to valid string sufficient' do
        let(:params) {{ :login_pam_access => 'sufficient' }}

        if os =~ /el/ or os == 'suse11'
          it { should contain_file('pam_d_login').with_content(/^account[\s]+sufficient[\s]+pam_access.so$/) }
        elsif v[:facts_hash][:osfamily] != 'Solaris'
          it { should contain_file('pam_d_login').without_content(/account[\s]+sufficient[\s]+pam_access.so/) }
        else
          it { should_not contain_file('pam_d_login') }
        end
      end

      context 'with sshd_pam_access set to valid string sufficient' do
        let(:params) {{ :sshd_pam_access => 'sufficient' }}

        if os =~ /(debian|el|ubuntu)/ or os == 'suse11'
          it { should contain_file('pam_d_sshd').with_content(/^account[\s]+sufficient[\s]+pam_access.so$/) }
        elsif v[:facts_hash][:osfamily] != 'Solaris'
          it { should contain_file('pam_d_sshd').without_content(/account[\s]+sufficient[\s]+pam_access.so/) }
        else
          it { should_not contain_file('pam_d_sshd') }
        end
      end

      context 'with pam_conf_file set to a valid absolute path /etc/test.d' do
        let(:params) { { :pam_conf_file => '/etc/test.conf' } }

        if os == 'solaris9' or os == 'solaris10'
          it { should contain_file('pam_conf').with_path('/etc/test.conf') }
        else
          it { should_not contain_file('pam_conf') }
        end
      end

      context 'with pam_d_login_oracle_options set to a valid array' do
        let(:params) { { :pam_d_login_oracle_options => [ 'session required pam_spectest.so', 'session optional pam_spectest.so' ] } }

        if os == 'el5'
          it { should contain_file('pam_d_login').with_content(/^# oracle options\nsession required pam_spectest.so\nsession optional pam_spectest.so$/) }
        elsif os =~ /solaris.*/
          it { should_not contain_file('pam_d_login') }
        else
          it { should contain_file('pam_d_login').without_content(/^# oracle options\nsession required pam_spectest.so\nsession optional pam_spectest.so$/) }
        end
      end

      context 'with pam_auth_lines set to a valid array' do
        let(:params) { { :pam_auth_lines => [ 'auth_line1', 'auth_line2'  ] } }
        content_regex = '# Auth\nauth_line1\nauth_line2'

        if os == 'solaris11' or os == 'suse9'
          it { should contain_file('pam_other').with_content(/#{content_regex}/) }
        elsif os =~ /solaris/
          it { should contain_file('pam_conf').with_content(/#{content_regex}/) }
        elsif os =~ /(debian|ubuntu)/ or os == 'suse10'
          it { should contain_file('pam_common_auth').with_content(/#{content_regex}/) }
        elsif os =~ /el/
          it { should contain_file('pam_system_auth_ac').with_content(/#{content_regex}/) }
        else
          it { should contain_file('pam_common_auth_pc').with_content(/#{content_regex}/) }
        end
      end

      context 'with pam_account_lines set to a valid array' do
        let(:params) { { :pam_account_lines => [ 'account_line1', 'account_line2'  ] } }
        content_regex = '# Account\naccount_line1\naccount_line2'

        if os == 'solaris11' or os == 'suse9'
          it { should contain_file('pam_other').with_content(/#{content_regex}/) }
        elsif os =~ /solaris/
          it { should contain_file('pam_conf').with_content(/#{content_regex}/) }
        elsif os =~ /(debian|ubuntu)/ or os == 'suse10'
          it { should contain_file('pam_common_account').with_content(/#{content_regex}/) }
        elsif os =~ /el/
          it { should_not contain_file('pam_system_account_ac') }
        else
          it { should contain_file('pam_common_account_pc').with_content(/#{content_regex}/) }
        end
      end

      context 'with pam_account_lines set to a valid array' do
        let(:params) { { :pam_account_lines => [ 'account_line1', 'account_line2'  ] } }
        content_regex = '# Account\naccount_line1\naccount_line2'

        if os == 'solaris11' or os == 'suse9'
          it { should contain_file('pam_other').with_content(/#{content_regex}/) }
        elsif os =~ /solaris/
          it { should contain_file('pam_conf').with_content(/#{content_regex}/) }
        elsif os =~ /(debian|ubuntu)/ or os == 'suse10'
          it { should contain_file('pam_common_account').with_content(/#{content_regex}/) }
        elsif os =~ /el/
          it { should_not contain_file('pam_system_account_ac') }
        else
          it { should contain_file('pam_common_account_pc').with_content(/#{content_regex}/) }
        end
      end

      context 'with pam_account_lines set to a valid array' do
        let(:params) { { :pam_account_lines => [ 'account_line1', 'account_line2'  ] } }
        content_regex = '# Account\naccount_line1\naccount_line2'

        if os == 'solaris11' or os == 'suse9'
          it { should contain_file('pam_other').with_content(/#{content_regex}/) }
        elsif os =~ /solaris/
          it { should contain_file('pam_conf').with_content(/#{content_regex}/) }
        elsif os =~ /(debian|ubuntu)/ or os == 'suse10'
          it { should contain_file('pam_common_account').with_content(/#{content_regex}/) }
        elsif os =~ /el/
          it { should_not contain_file('pam_system_account_ac') }
        else
          it { should contain_file('pam_common_account_pc').with_content(/#{content_regex}/) }
        end
      end

      context 'with pam_password_lines set to a valid array' do
        let(:params) { { :pam_password_lines => [ 'password_line1', 'password_line2'  ] } }
        content_regex = '# Password\npassword_line1\npassword_line2'

        if os == 'solaris11' or os == 'suse9'
          it { should contain_file('pam_other').with_content(/#{content_regex}/) }
        elsif os =~ /solaris/
          it { should contain_file('pam_conf').with_content(/#{content_regex}/) }
        elsif os =~ /(debian|ubuntu)/ or os == 'suse10'
          it { should contain_file('pam_common_password').with_content(/#{content_regex}/) }
        elsif os =~ /el/
          it { should_not contain_file('pam_system_password_ac') }
        else
          it { should contain_file('pam_common_password_pc').with_content(/#{content_regex}/) }
        end
      end

      context 'with pam_session_lines set to a valid array' do
        let(:params) { { :pam_session_lines => [ 'session_line1', 'session_line2'  ] } }
        content_regex = '# Session\nsession_line1\nsession_line2'

        if os == 'solaris11' or os == 'suse9'
          it { should contain_file('pam_other').with_content(/#{content_regex}/) }
        elsif os =~ /solaris/
          it { should contain_file('pam_conf').with_content(/#{content_regex}/) }
        elsif os =~ /(debian|ubuntu)/ or os == 'suse10'
          it { should contain_file('pam_common_session').with_content(/#{content_regex}/) }
        elsif os =~ /el/
          it { should_not contain_file('pam_system_session_ac') }
        else
          it { should contain_file('pam_common_session_pc').with_content(/#{content_regex}/) }
        end
      end

      context 'with pam_password_auth_lines set to a valid array' do
        let(:params) { { :pam_password_auth_lines => [ 'password_auth_line1', 'password_auth_line2'  ] } }
        content_regex = '# Auth\npassword_auth_line1\npassword_auth_line2'

        if os == 'el6' or os == 'el7'
          it { should contain_file('pam_password_auth_ac').with_content(/#{content_regex}/) }
        else
          it { should_not contain_file('pam_password_auth_ac') }
        end
      end

      context 'with pam_password_account_lines set to a valid array' do
        let(:params) { { :pam_password_account_lines => [ 'password_account_line1', 'password_account_line2'  ] } }
        content_regex = '# Account\npassword_account_line1\npassword_account_line2'

        if os == 'el6' or os == 'el7'
          it { should contain_file('pam_password_auth_ac').with_content(/#{content_regex}/) }
        else
          it { should_not contain_file('pam_password_auth_ac') }
        end
      end

      context 'with pam_password_password_lines set to a valid array' do
        let(:params) { { :pam_password_password_lines => [ 'password_password_line1', 'password_password_line2'  ] } }
        content_regex = '# Password\npassword_password_line1\npassword_password_line2'

        if os == 'el6' or os == 'el7'
          it { should contain_file('pam_password_auth_ac').with_content(/#{content_regex}/) }
        else
          it { should_not contain_file('pam_password_auth_ac') }
        end
      end

      context "with pam_password_session_lines set to a valid array on #{os}" do
        let(:params) { { :pam_password_session_lines => [ 'password_session_line1', 'password_session_line2'  ] } }
        content_regex = '# Session\npassword_session_line1\npassword_session_line2'

        if os == 'el6' or os == 'el7'
          it { should contain_file('pam_password_auth_ac').with_content(/#{content_regex}/) }
        else
          it { should_not contain_file('pam_password_auth_ac') }
        end
      end

      context 'with login_pam_access set to valid string absent' do
        let(:params) {{ :login_pam_access => 'absent' }}

        if v[:facts_hash][:osfamily] != 'Solaris'
          it { should contain_file('pam_d_login').without_content(/^account.*pam_access.so$/) }
        end
      end

      context 'with sshd_pam_access set to valid string absent' do
        let(:params) {{ :sshd_pam_access => 'absent' }}

        if v[:facts_hash][:osfamily] != 'Solaris'
          it { should contain_file('pam_d_sshd').without_content(/^account.*pam_access.so$/) }
        end
      end
    end
  end

  describe 'variable data type and content validations' do
    validations = {
      'Array' => {
        :name    => %w(pam_d_login_oracle_options),
        :valid   => [%w(array)],
        :invalid => ['string', { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects an Array', # Puppet 4 & 5
      },
      'Array for common_files' => {
        :name    => %w(common_files),
        :valid   => [%w(system_auth)],
        :invalid => ['string', { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects an Array', # Puppet 4 & 5
      },
      'Boolean' => {
        :name    => %w(common_files_create_links limits_fragments_hiera_merge manage_nsswitch),
        :valid   => [true, false],
        :invalid => ['string', %w(array), { 'ha' => 'sh' }, 3, 2.42, 'false', nil],
        :message => 'expects a Boolean value', # Puppet 4 & 5
      },
      'Enum for *_pam_access' => {
        :name    => %w(login_pam_access sshd_pam_access),
        :valid   => %w(absent optional required requisite sufficient),
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a match for Enum\[\'absent\', \'optional\', \'required\', \'requisite\', \'sufficient\'\]', # Puppet  4 & 5
      },
      'Optional[Array]' => {
        :name    => %w(pam_auth_lines pam_account_lines pam_password_lines pam_session_lines pam_password_auth_lines pam_password_account_lines pam_password_password_lines pam_password_session_lines),
        :valid   => [%w(array)],
        :invalid => ['string', { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects a value of type Undef or Array', # Puppet 4 & 5
      },
      'Optional[Array] for pam_sshd_*_lines' => {
        :name    => %w(pam_sshd_auth_lines pam_sshd_account_lines pam_sshd_password_lines pam_sshd_session_lines),
        :params  => { :pam_d_sshd_template => 'pam/sshd.custom.erb', :pam_sshd_auth_lines => ['#'], :pam_sshd_account_lines => ['#'], :pam_sshd_password_lines => ['#'], :pam_sshd_session_lines => ['#']},
        :valid   => [%w(array)],
        :invalid => ['string', { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a value of type Undef or Array', # Puppet 4 & 5
      },
      'Optional[Hash]' => {
        :name    => %w(services limits_fragments),
        :valid   => [], # valid hashes are to complex to block test them here. Subclasses have their own specific spec tests anyway.
        :invalid => ['string', 3, 2.42, %w(array), false, nil],
        :message => 'expects a value of type Undef or Hash', # Puppet 4 & 5
      },
      'Optional[String] for common_files_suffix' => {
        :name    => %w(common_files_suffix),
        :valid   => ['_ac'],
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a value of type Undef or String', # Puppet 4 & 5
      },
      'Optional[String] for pam_d_*_template' => {
        :name    => %w(pam_d_login_template pam_d_sshd_template),
        :valid   => %w(pam/other.erb),
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a value of type Undef or String', # Puppet 4 & 5
      },
# /!\ need fix, fails in pam::accesslogin
# Failure/Error: it { should compile }
#   error during compilation: Could not retrieve dependency 'Package[pam]' of File[access_conf]
#
#      'Optional[Variant[Array, String]]' => {
#        :name    => %w(package_name),
#        :valid   => ['string', %w(array)],
#        :invalid => [{ 'ha' => 'sh' }, 3, 2.42, false],
#        :message => 'expects a value of type Undef, Array, or String', # Puppet 4 & 5
#      },
      'Stdlib::Absolutepath' => {
        :name    => %w(common_account_file common_account_pc_file common_auth_file common_auth_pc_file common_password_file common_password_pc_file common_session_file common_session_noninteractive_file common_session_pc_file other_file pam_conf_file pam_d_login_path pam_d_sshd_path password_auth_ac_file password_auth_file system_auth_ac_file system_auth_file),
        :valid   => ['/absolute/filepath', '/absolute/directory/'],
        :invalid => ['../invalid', %w(array), { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects a (match for|match for Stdlib::Absolutepath =|Stdlib::Absolutepath =) Variant\[Stdlib::Windowspath.*Stdlib::Unixpath', # Puppet (4.x|5.0 & 5.1|5.x)
      },
      'Stdlib::Filemode' => {
        :name    => %w(pam_d_login_mode pam_d_sshd_mode),
        :valid   => %w(0644 0755 0640 0740),
        :invalid => [ 2770, '0844', '755', '00644', 'string', %w(array), { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects a match for Stdlib::Filemode',  # Puppet 4 & 5
      },
      'String' => {
        :name    => %w(pam_d_login_owner pam_d_login_group pam_d_sshd_owner pam_d_sshd_group),
        :valid   => %w(string),
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a String value', # Puppet 4 & 5
      },
    }

    validations.sort.each do |type, var|
      mandatory_params = {} if mandatory_params.nil?
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:facts) { [mandatory_facts, var[:facts]].reduce(:merge) } if ! var[:facts].nil?
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => valid, }].reduce(:merge) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => invalid, }].reduce(:merge) }
            it 'should fail' do
              expect { should contain_class(subject) }.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end

# /!\ untested functionality
# $limits_fragments_hiera_merge
# $other_file
# $common_auth_file
# $common_auth_pc_file
# $common_account_file
# $common_account_pc_file
# $common_password_file
# $common_password_pc_file
# $common_session_file
# $common_session_pc_file
# $common_session_noninteractive_file
# $system_auth_file
# $system_auth_ac_file
# $password_auth_file
# $password_auth_ac_file
# $common_files
# $common_files_create_links
# $common_files_suffix
