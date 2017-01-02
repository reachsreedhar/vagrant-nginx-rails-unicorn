#!/bin/bash -x

sudo cp templates/root.bashrc ~root/.bashrc

mkdir -p ~vagrant/.ssh
chmod 700 ~vagrant/.ssh
#cp -p /vagrant/shared/id_rsa ~vagrant/.ssh/id_rsa
echo "Copy the private key!"
cp -p templates/vagrant.bashrc ~vagrant/.bashrc
cp -p templates/ssh.config ~vagrant/.ssh/config

