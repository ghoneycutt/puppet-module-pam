# These functions provide the same values as used in hiera

def os_id(os)
  # for CentOS, OracleLinux, Scientific use RedHat values
  os.sub(%r{(centos|oraclelinux|scientific)}, 'redhat')
end

def packages(os)
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

def files(os)
  case os_id(os)
  when %r{redhat-6}
    ['pam_system_auth', 'pam_password_auth']
  when %r{redhat}
    ['pam_system_auth']
  when %r{sles-9}
    ['pam_other']
  when %r{sles}
    ['pam_common_account', 'pam_common_auth', 'pam_common_password', 'pam_common_session']
  when %r{solaris-9}, %r{solaris-10}
    ['pam_conf']
  when %r{solaris}
    ['pam_other']
  when %r{debian}, %r{ubuntu}
    ['pam_common_auth', 'pam_common_account', 'pam_common_password', 'pam_common_session', 'pam_common_session_noninteractive']
  end
end

def files_suffix(os)
  case os_id(os)
  when %r{redhat}
    '_ac'
  when %r{sles-11}
    '_pc'
  when %r{sles-12}
    '_pc'
  when %r{sles-15}
    '_pc'
  else
    ''
  end
end

def pam_d_login(os)
  case os_id(os)
  when %r{redhat-5}, %r{redhat-6}, %r{redhat-7}, %r{sles-11}
    true
  when %r{redhat}, %r{sles}, %r{debian}, %r{ubuntu}
    false
  else
    nil
  end
end

def pam_d_sshd(os)
  case os_id(os)
  when %r{redhat-5}, %r{redhat-6}, %r{redhat-7}, %r{sles-11}, %r{debian}, %r{ubuntu}
    true
  when %r{redhat-8}, %r{sles-9}, %r{sles-10}, %r{sles-12}, %r{sles-15}
    false
  else
    nil
  end
end

def symlink(os)
  case os_id(os)
  when %r{redhat}, %r{sles-11}, %r{sles-12}, %r{sles-15}
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
