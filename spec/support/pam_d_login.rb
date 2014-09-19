shared_context "pam_d_login-default" do
  it do
    verify_contents(subject, 'pam_d_login', default_lines)
  end

  it do
    should contain_file('pam_d_login').with({
      'ensure' => 'file',
      'path'   => '/etc/pam.d/login',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
  end
end

shared_context "pam_d_login-params" do
  context 'when login_pam_access => "sufficient"' do
    let(:params) {{ :login_pam_access => "sufficient" }}

    it do
      should contain_file('pam_d_login').with_content(/^account\s+sufficient\s+pam_access.so$/)
    end
  end

  context 'when login_pam_access => "absent"' do
    let(:params) {{ :login_pam_access => "absent" }}

    it do
      should_not contain_file('pam_d_login').with_content(/pam_access.so/)
    end
  end

  context 'when login_pam_access => "foo"' do
    let(:params) {{ :login_pam_access => "foo" }}

    it "should raise error" do
      expect { should compile }.to raise_error(/does not match/)
    end
  end
end

shared_examples_for 'pam_d_login-el5' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so',
      'auth       include      system-auth',
      'account    required     pam_nologin.so',
      'account    include      system-auth',
      'account    required     pam_access.so',
      'password   include      system-auth',
      '# pam_selinux.so close should be the first session rule',
      'session    required     pam_selinux.so close',
      'session    optional     pam_keyinit.so force revoke',
      'session    required     pam_loginuid.so',
      'session    include      system-auth',
      'session    optional     pam_console.so',
      '# pam_selinux.so open should only be followed by sessions to be executed in the user context',
      'session    required     pam_selinux.so open',
    ]
  end


  include_context "pam_d_login-default"
  include_context "pam_d_login-params"
end

shared_examples_for 'pam_d_login-el6' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so',
      'auth       include      system-auth',
      'account    required     pam_nologin.so',
      'account    include      system-auth',
      'account    required     pam_access.so',
      'password   include      system-auth',
      '# pam_selinux.so close should be the first session rule',
      'session    required     pam_selinux.so close',
      'session    required     pam_loginuid.so',
      'session    optional     pam_console.so',
      '# pam_selinux.so open should only be followed by sessions to be executed in the user context',
      'session    required     pam_selinux.so open',
      'session    required     pam_namespace.so',
      'session    optional     pam_keyinit.so force revoke',
      'session    include      system-auth',
      '-session   optional     pam_ck_connector.so',
    ]
  end

  include_context "pam_d_login-default"
  include_context "pam_d_login-params"
end

shared_examples_for 'pam_d_login-ubuntu12.04' do
  let(:default_lines) do
    [
      'auth     optional   pam_faildelay.so  delay=3000000',
      'auth     [success=ok new_authtok_reqd=ok ignore=ignore user_unknown=bad default=die] pam_securetty.so',
      'auth     requisite  pam_nologin.so',
      'session  [success=ok ignore=ignore module_unknown=ignore default=bad] pam_selinux.so close',
      'session  required   pam_env.so readenv=1',
      'session  required   pam_env.so readenv=1 envfile=/etc/default/locale',
      '@include common-auth',
      'auth     optional   pam_group.so',
      'session  required   pam_limits.so',
      'session  optional   pam_lastlog.so',
      'session  optional   pam_motd.so',
      'session  optional   pam_mail.so standard',
      '@include common-account',
      '@include common-session',
      '@include common-password',
      'session  [success=ok ignore=ignore module_unknown=ignore default=bad] pam_selinux.so open',
    ]
  end

  include_context "pam_d_login-default"
end

shared_examples_for 'pam_d_login-suse10' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth      required  pam_securetty.so',
      'auth      include   common-auth',
      'auth      required  pam_nologin.so',
      'account   include   common-account',
      'password  include   common-password',
      'session   include   common-session',
      'session   required  pam_lastlog.so nowtmp',
      'session   required  pam_resmgr.so',
      'session   optional  pam_mail.so standard',
    ]
  end

  include_context "pam_d_login-default"
end

shared_examples_for 'pam_d_login-suse11' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth      requisite      pam_nologin.so',
      'auth      [user_unknown=ignore success=ok ignore=ignore auth_err=die default=bad]        pam_securetty.so',
      'auth      include        common-auth',
      'account   include        common-account',
      'account   required       pam_access.so',
      'password  include        common-password',
      'session   required       pam_loginuid.so',
      'session   include        common-session',
      'session   required       pam_lastlog.so  nowtmp',
      'session   optional       pam_mail.so standard',
      'session   optional       pam_ck_connector.so',
    ]
  end

  include_context "pam_d_login-default"
  include_context "pam_d_login-params"
end
