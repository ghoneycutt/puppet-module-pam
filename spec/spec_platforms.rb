# These functions provide the same values as used in hiera

def os_id(os)
  # for OracleLinux use RedHat values
  os.sub(%r{oraclelinux}, 'redhat')
end

def package_name(os)
  case os_id(os)
  when %r{redhat}, %r{sles}, %r{sled}
    ['pam']
  when %r{debian}, %r{ubuntu}
    ['libpam0g']
  end
end

def common_files(os)
  case os_id(os)
  when %r{redhat}
    ['password_auth', 'system_auth']
  when %r{sles}, %r{sled}
    ['common_account', 'common_auth', 'common_password', 'common_session']
  when %r{debian}, %r{ubuntu}
    ['common_account', 'common_auth', 'common_password', 'common_session', 'common_session_noninteractive']
  end
end

def common_files_suffix(os)
  case os_id(os)
  when %r{redhat-8}
    '_ac'
  when %r{sles-15}, %r{sled-15}
    '_pc'
  else
    ''
  end
end

def login_pam_access(os)
  case os_id(os)
  when %r{redhat}
    'required'
  when %r{sles}, %r{sled}, %r{debian}, %r{ubuntu}
    'absent'
  end
end

def sshd_pam_access(os)
  case os_id(os)
  when %r{redhat}, %r{debian}, %r{ubuntu}
    'required'
  when %r{sles}, %r{sled}
    'absent'
  end
end

def common_files_create_links(os)
  case os_id(os)
  when %r{redhat-8}, %r{sles-15}, %r{sled-15}
    true
  else
    false
  end
end

def dirpath(_os)
  '/etc/pam.d/'
end

def group(_os)
  'root'
end
