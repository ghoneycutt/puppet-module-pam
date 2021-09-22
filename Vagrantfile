# -*- mode: ruby -*-
# vi: set ft=ruby :
#
if not Vagrant.has_plugin?('vagrant-vbguest')
  abort <<-EOM

vagrant plugin vagrant-vbguest >= 0.16.0 is required.
https://github.com/dotless-de/vagrant-vbguest
To install the plugin, please run, 'vagrant plugin install vagrant-vbguest'.

  EOM
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  config.vm.define "el8-pam", autostart: false do |c|
    c.vm.box = "centos/8"
    c.vm.hostname = 'el8-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_el.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end

  config.vm.define "el7-pam", autostart: true do |c|
    c.vm.box = "centos/7"
    c.vm.hostname = 'el7-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_el.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end

  config.vm.define "el6-pam", autostart: false do |c|
    c.vm.box = "centos/6"
    c.vm.hostname = 'el6-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_el.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end

  config.vm.define "debian9-pam", autostart: false do |c|
    c.vm.box = "debian/stretch64"
    c.vm.hostname = 'debian9-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_debian.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end

  config.vm.define "debian10-pam", autostart: false do |c|
    c.vm.box = "debian/buster64"
    c.vm.hostname = 'debian10-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_debian.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end

  config.vm.define "debian11-pam", autostart: false do |c|
    c.vm.box = "debian/bullseye64"
    c.vm.hostname = 'debian11-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_debian.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end

  config.vm.define "ubuntu1604-pam", autostart: false do |c|
    c.vm.box = "ubuntu/xenial64"
    c.vm.hostname = 'ubuntu1604-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_debian.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end

  config.vm.define "ubuntu1804-pam", autostart: false do |c|
    c.vm.box = "ubuntu/bionic64"
    c.vm.hostname = 'ubuntu1804-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_debian.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end

  config.vm.define "ubuntu2004-pam", autostart: false do |c|
    c.vm.box = "ubuntu/focal64"
    c.vm.hostname = 'ubuntu2004-pam.example.com'
    c.vm.provision :shell, :path => "tests/provision_basic_debian.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/tests/init.pp"
  end
end
