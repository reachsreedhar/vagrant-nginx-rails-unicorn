#!/bin/bash

if [ $(id -u) -ne 0 ];then
  echo "ERROR: Run this under sudo or as root"
  exit 0
fi

. ~/.bashrc
SE_FILE=/etc/selinux/config

TO="SELINUX=disabled"
FROM="SELINUX=enforcing"
sed -i "s/${FROM}/${TO}/" ${SE_FILE}
echo;echo "        **** Reload the vagrant machine ****";echo;echo
