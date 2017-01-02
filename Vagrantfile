# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/6"
  config.ssh.insert_key = false
  config.vm.network "forwarded_port", guest: 84, host: 8084
  config.vm.network "forwarded_port", guest: 3004, host: 3004
  config.vm.network "private_network", ip: "192.168.33.111"
  config.vm.synced_folder "/Users/sreedhar/kcs/vagrant/kcstest/shared", "/vagrant/shared", id: "vagrant", :mount_options => ["uid=500,gid=500"]
end
