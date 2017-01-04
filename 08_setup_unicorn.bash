#!/bin/bash

export RAILS_PORT=$1
export APP_NAME=$2

if [ -z ${RAILS_PORT} ] || [ -z ${APP_NAME} ];then
  echo "USAGE: $0 <Rails port no> <Application name>"
  echo "Example: $0 3003 dbaexpert"
  exit 0
fi

APP_ROOT="/vagrant/shared/$APP_NAME"
UNI_CONFIG_FILE=/vagrant/shared/${APP_NAME}/config/unicorn.rb
UNI_START_SCRIPT=/vagrant/shared/${APP_NAME}/unicorn.sh
mkdir -p ${APP_ROOT}/shared/log
mkdir -p /home/vagrant/pids

if [ ! -f ${UNI_CONFIG_FILE} ];then
  cp templates/unicorn.rb ${UNI_CONFIG_FILE}
  sed -i "s/<<APPNAME>>/${APP_NAME}/" ${UNI_CONFIG_FILE}
  sed -i "s/<<RAILS_PORT>>/${RAILS_PORT}/" ${UNI_CONFIG_FILE}
fi
if [ ! -f ${UNI_START_SCRIPT} ];then
  cp templates/unicorn.sh ${UNI_START_SCRIPT}
  sed -i "s/<<APPNAME>>/${APP_NAME}/" ${UNI_START_SCRIPT}
fi
if [ ! -f /etc/init.d/unicorn ];then
  sudo ln -s ${UNI_START_SCRIPT} /etc/init.d/unicorn
fi
sudo chkconfig --list unicorn
STAT=$?

if [ ${STAT} -ne 0 ];then
  sudo chkconfig --add unicorn
  sudo chkconfig unicorn on
  sudo chkconfig --list unicorn
fi

sudo service unicorn start
