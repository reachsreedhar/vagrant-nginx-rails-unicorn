#!/bin/bash 

sudo cp templates/root.bashrc ~root/.bashrc

mkdir -p ~vagrant/.ssh
chmod 700 ~vagrant/.ssh
cp -p templates/vagrant.bashrc ~vagrant/.bashrc
cp -p templates/ssh.config ~vagrant/.ssh/config

echo;echo;
echo "Source .bashrc since it has been modified!"
echo "Copy the private key! and run the below command"
echo "cp -p /vagrant/shared/id_rsa ~vagrant/.ssh/id_rsa;rm /vagrant/shared/id_rsa"
echo;echo
