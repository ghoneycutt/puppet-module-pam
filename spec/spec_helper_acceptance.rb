require 'beaker-rspec'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/acceptance/support/*.rb"].sort.each { |f| require f }

hosts.each do |host|
  # Install Puppet
  install_puppet unless ENV['BEAKER_provision'] == 'no'

  # Temporary fix till PR #67 is merged
  osfamily = fact_on host, 'osfamily'
  if osfamily == 'RedHat'
    install_package host, 'redhat-lsb'
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'pam')

    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version', '">= 3.2.00"'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'ghoneycutt-common', '--version', '">= 1.0.2"'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'ghoneycutt-nsswitch', '--version', '">= 1.1.0"'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
