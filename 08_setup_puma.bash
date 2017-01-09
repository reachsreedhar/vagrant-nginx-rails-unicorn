#!/bin/bash

export RAILS_PORT=$1
export APP_NAME=$2

if [ -z ${RAILS_PORT} ] || [ -z ${APP_NAME} ];then
  echo "USAGE: $0 <Rails port no> <Application name>"
  echo "Example: $0 3003 dbaexpert"
  exit 0
fi

APP_ROOT="/vagrant/shared/$APP_NAME"
PUMA_CONFIG_FILE=/vagrant/shared/${APP_NAME}/config/puma.rb
PUMA_START_SCRIPT=/vagrant/shared/${APP_NAME}/puma.sh
mkdir -p ${APP_ROOT}/shared/log
mkdir -p /home/vagrant/pids

if [ ! -f ${PUMA_CONFIG_FILE} ];then
  cp templates/puma.rb ${PUMA_CONFIG_FILE}
  sed -i "s/<<APPNAME>>/${APP_NAME}/" ${PUMA_CONFIG_FILE}
  sed -i "s/<<RAILS_PORT>>/${RAILS_PORT}/" ${PUMA_CONFIG_FILE}
fi
if [ ! -f ${PUMA_START_SCRIPT} ];then
  cp templates/puma.sh ${PUMA_START_SCRIPT}
  sed -i "s/<<APPNAME>>/${APP_NAME}/" ${PUMA_START_SCRIPT}
fi
if [ ! -f /etc/init.d/puma ];then
  sudo ln -s ${PUMA_START_SCRIPT} /etc/init.d/puma
fi
sudo chkconfig --list puma
STAT=$?

if [ ${STAT} -ne 0 ];then
  sudo chkconfig --add puma
  sudo chkconfig puma on
  sudo chkconfig --list puma
fi

sudo service puma start
