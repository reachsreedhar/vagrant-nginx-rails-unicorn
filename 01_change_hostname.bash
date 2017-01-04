#!/bin/bash

if [ $(id -u) -ne 0 ];then
  echo "ERROR: Run this under sudo or as root"
  exit 0
fi

HN=$1

if [ -z ${HN} ];then
  echo "USAGE: $0 <Hostname>"
  exit 0
fi

. ~/.bashrc

NW_FILE=/etc/sysconfig/network

sed -i "s/localhost.localdomain/${HN}/" ${NW_FILE}
hostname ${HN}

HOSTS_FILE=/etc/hosts
if [ $(grep ${HN} ${HOSTS_FILE} | wc -l) -le 0 ];then
  echo "Updating ${HOSTS_FILE} for ${HN}"
  sed -i "s/localhost4.localdomain4/localhost4.localdomain4 ${HN}/" ${HOSTS_FILE}
else
  echo "${HOSTS_FILE} already updated for ${HN}"
fi
echo "Relog back in"
