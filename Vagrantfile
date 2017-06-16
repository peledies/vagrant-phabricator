# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/xenial64"
  
  # Prevent "Inappropriate ioctl for device" message
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.define :phabricator do |phabricator|
  end

  # We have to use port 3000 because it is whitelisted by Auth0
  config.vm.network :forwarded_port, host: 8010, guest: 80
  config.vm.network :forwarded_port, host: 3310, guest: 3306

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.synced_folder "./", "/home/ubuntu/phabricator", owner: "www-data", group: "www-data", mount_options: ["dmode=777", "fmode=777"]

  # Provision Apache
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/provision/provision_apache.sh"
    s.args = "phabricator.local deac@sfp.net /opt/phabricator/webroot"
  end

  # Provision MySql
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/provision/provision_mysql.sh"
    s.args = "phabricator secret"
  end

  # Provision PHP 7
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/provision/provision_php_71.sh"
  end

  # Provision phabricator
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/provision/provision_phabricator.sh"
    s.args = "phabricator.local"
  end

end
