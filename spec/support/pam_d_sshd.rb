shared_context "pam_d_sshd-default" do
  it do
    verify_contents(subject, 'pam_d_sshd', default_lines)
  end

  it do
    should contain_file('pam_d_sshd').with({
      'ensure' => 'file',
      'path'   => '/etc/pam.d/sshd',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
  end
end

shared_context "pam_d_sshd-params" do
  context 'when sshd_pam_access => "sufficient"' do
    let(:params) {{ :sshd_pam_access => "sufficient" }}

    it do
      should contain_file('pam_d_sshd').with_content(/^account\s+sufficient\s+pam_access.so$/)
    end
  end

  context 'when sshd_pam_access => "absent"' do
    let(:params) {{ :sshd_pam_access => "absent" }}

    it do
      should_not contain_file('pam_d_sshd').with_content(/pam_access.so/)
    end
  end

  context 'when sshd_pam_access => "foo"' do
    let(:params) {{ :sshd_pam_access => "foo" }}

    it "should raise error" do
      expect { should compile }.to raise_error(/does not match/)
    end
  end
end

shared_examples_for 'pam_d_sshd-el5' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth       include      system-auth',
      'account    required     pam_nologin.so',
      'account    include      system-auth',
      'account    required     pam_access.so',
      'password   include      system-auth',
      'session    optional     pam_keyinit.so force revoke',
      'session    include      system-auth',
      'session    required     pam_loginuid.so',
    ]
  end


  include_context "pam_d_sshd-default"
  include_context "pam_d_sshd-params"
end

shared_examples_for 'pam_d_sshd-el6' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth       required     pam_sepermit.so',
      'auth       include      password-auth',
      'account    required     pam_access.so',
      'account    required     pam_nologin.so',
      'account    include      password-auth',
      'password   include      password-auth',
      '# pam_selinux.so close should be the first session rule',
      'session    required     pam_selinux.so close',
      'session    required     pam_loginuid.so',
      '# pam_selinux.so open should only be followed by sessions to be executed in the user context',
      'session    required     pam_selinux.so open env_params',
      'session    optional     pam_keyinit.so force revoke',
      'session    include      password-auth',
    ]
  end

  include_context "pam_d_sshd-default"
  include_context "pam_d_sshd-params"
end

shared_examples_for 'pam_d_sshd-el7' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth       required     pam_sepermit.so',
      'auth       substack     password-auth',
      'auth       include      postlogin',
      'account    required     pam_access.so',
      'account    required     pam_nologin.so',
      'account    include      password-auth',
      'password   include      password-auth',
      '# pam_selinux.so close should be the first session rule',
      'session    required     pam_selinux.so close',
      'session    required     pam_loginuid.so',
      '# pam_selinux.so open should only be followed by sessions to be executed in the user context',
      'session    required     pam_selinux.so open env_params',
      'session    optional     pam_keyinit.so force revoke',
      'session    include      password-auth',
      'session    include      postlogin',
    ]
  end

  include_context "pam_d_sshd-default"
  include_context "pam_d_sshd-params"
end

shared_examples_for 'pam_d_sshd-ubuntu12.04' do
  let(:default_lines) do
    [
      'auth       required     pam_env.so # [1]',
      'auth       required     pam_env.so envfile=/etc/default/locale',
      '@include common-auth',
      'account    required     pam_nologin.so',
      '@include common-account',
      '@include common-session',
      'session    optional     pam_motd.so # [1]',
      'session    optional     pam_mail.so standard noenv # [1]',
      'session    required     pam_limits.so',
      '@include common-password',
    ]
  end

  include_context "pam_d_sshd-default"
end

shared_examples_for 'pam_d_sshd-suse10' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth      include   common-auth',
      'auth      required  pam_nologin.so',
      'account   include   common-account',
      'password  include   common-password',
      'session   include   common-session',
    ]
  end

  include_context "pam_d_sshd-default"
end

shared_examples_for 'pam_d_sshd-suse11' do
  let(:default_lines) do
    [
      '#%PAM-1.0',
      'auth      requisite      pam_nologin.so',
      'auth      include        common-auth',
      'account   required       pam_access.so',
      'account   requisite      pam_nologin.so',
      'account   include        common-account',
      'password  include        common-password',
      'session   required       pam_loginuid.so',
      'session   include        common-session',
    ]
  end

  include_context "pam_d_sshd-default"
  include_context "pam_d_sshd-params"
end