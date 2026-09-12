def os_id(os)
  case os
  when %r{^redhat-2}  then 'redhat-2-x86_64'
  when %r{^redhat-5}  then 'redhat-5-x86_64'
  when %r{^redhat-6}  then 'redhat-6-x86_64'
  when %r{^redhat-7}  then 'redhat-7-x86_64'
  when %r{^redhat-8}  then 'redhat-8-x86_64'
  when %r{^redhat-9}  then 'redhat-9-x86_64'
  when %r{^redhat-10} then 'redhat-10-x86_64'
  when %r{^sles-9}    then 'sles-9'
  when %r{^sles-10}   then 'sles-10'
  when %r{^sles-11}   then 'sles-11'
  when %r{^sles-12}   then 'sles-12'
  when %r{^sles-15}   then 'sles-15'
  when %r{^debian}    then 'debian'
  when %r{^ubuntu}    then 'ubuntu'
  else nil
  end
end

def package_name(os)
  case os_id(os)
  when %r{redhat}
    ['pam']
  when %r{sles}, %r{debian}, %r{ubuntu}
    ['libpam-modules']
  else
    []
  end
end

# Use splat operator to satisfy RuboCop Lint/UnusedMethodArgument rule
def group(*)
  'root'
end

def common_files(os)
  case os_id(os)
  when %r{redhat-10}
    ['system_auth', 'password_auth']
  when %r{redhat-8}, %r{redhat-9}
    ['system_auth', 'password_auth', 'fingerprint_auth', 'smartcard_auth']
  when %r{redhat-2}, %r{redhat-5}, %r{redhat-6}, %r{redhat-7}
    ['system_auth', 'password_auth']
  when %r{sles}
    ['common-auth', 'common-account', 'common-password', 'common-session']
  else
    []
  end
end

def common_files_suffix(os)
  case os_id(os)
  when %r{redhat-7}, %r{redhat-8}
    '_ac'
  else
    ''
  end
end

def dirpath(os)
  case os_id(os)
  when %r{redhat}, %r{sles}
    '/etc/pam.d/'
  else
    '/etc/'
  end
end

def login_pam_access(os)
  case os_id(os)
  when %r{redhat}, %r{sles-11}
    'required'
  when %r{sles}, %r{debian}, %r{ubuntu}
    'absent'
  else
    nil
  end
end

def sshd_pam_access(os)
  case os_id(os)
  when %r{redhat}, %r{sles-11}, %r{debian}, %r{ubuntu}
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
