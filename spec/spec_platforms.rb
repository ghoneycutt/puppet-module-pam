# These functions provide the same values as used in hiera

def os_id(os)
  # for CentOS, OracleLinux, Scientific use RedHat values
  os.sub(%r{(centos|oraclelinux|scientific)}, 'redhat')
end

def package_name(os)
  case os_id(os)
  when %r{redhat-5}
    ['pam', 'util-linux']
  when %r{redhat}
    ['pam']
  when %r{sles-9}
    ['pam', 'pam-modules']
  when %r{sles}
    ['pam']
  when %r{solaris}
    []
  when %r{debian}, %r{ubuntu}
    ['libpam0g']
  end
end

def common_files(os)
  case os_id(os)
  when %r{redhat-5}
    ['system_auth']
  when %r{redhat}
    ['password_auth', 'system_auth']
  when %r{sles-9}
    ['other']
  when %r{sles}
    ['common_account', 'common_auth', 'common_password', 'common_session']
  when %r{solaris-9}, %r{solaris-10}
    ['conf']
  when %r{solaris}
    ['other']
  when %r{debian}, %r{ubuntu}
    ['common_account', 'common_auth', 'common_password', 'common_session', 'common_session_noninteractive']
  end
end

def common_files_suffix(os)
  case os_id(os)
  when %r{redhat-(5|6|7|8)}
    '_ac'
  when %r{sles-11}, %r{sles-12}, %r{sles-15}
    '_pc'
  else
    ''
  end
end

def login_pam_access(os)
  case os_id(os)
  when %r{redhat-5}, %r{redhat-6}, %r{redhat-7}, %r{redhat-8}, %r{redhat-9}, %r{sles-11}
    'required'
  when %r{redhat}, %r{sles}, %r{debian}, %r{ubuntu}
    'absent'
  else
    nil
  end
end

def sshd_pam_access(os)
  case os_id(os)
  when %r{redhat-5}, %r{redhat-6}, %r{redhat-7}, %r{redhat-8}, %r{redhat-9}, %r{sles-11}, %r{debian}, %r{ubuntu}
    'required'
  when %r{sles-9}, %r{sles-10}, %r{sles-12}, %r{sles-15}
    'absent'
  else
    nil
  end
end

def common_files_create_links(os)
  case os_id(os)
  when %r{redhat-(5|6|7|8)}, %r{sles-11}, %r{sles-12}, %r{sles-15}
    true
  else
    false
  end
end

def dirpath(os)
  case os_id(os)
  when %r{solaris-9}, %r{solaris-10}
    '/etc/pam.'
  else
    '/etc/pam.d/'
  end
end

def group(os)
  case os_id(os)
  when %r{solaris}
    'sys'
  else
    'root'
  end
end
