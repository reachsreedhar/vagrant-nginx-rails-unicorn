#!/bin/bash

if [ $(id -u) -ne 0 ];then
  echo "ERROR: Run this under sudo or as root"
  exit 0
fi

. ~/.bashrc

if [ -f /usr/local/bin/ruby-install ];then
  echo "ruby-install is already installed!"
else
  DIR=/tmp/ruby-install
  mkdir ${DIR}
  cd ${DIR}
  set -x
  wget -O ruby-install-0.6.1.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz
  tar -xzvf ruby-install-0.6.1.tar.gz
  cd ruby-install-0.6.1/
  sudo make install
fi

if [ -d /opt/rubies/ruby-2.3.1 ];then
  echo "Ruby version 2.3.1 is already installed"
else
  ruby-install ruby 2.3.1
fi

exit 0
