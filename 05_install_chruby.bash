#!/bin/bash

if [ $(id -u) -ne 0 ];then
  echo "ERROR: Run this under sudo or as root"
  exit 0
fi

. ~/.bashrc

DIR=/tmp/chruby
mkdir ${DIR}
cd ${DIR}
set -x
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
sudo make install

echo "Source .bashrc since chruby has been installed just now!"
