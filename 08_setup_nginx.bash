#!/bin/bash

export RAILS_PORT=$1
export NGINX_PORT=$2
export APP_NAME=$3

if [ -z ${RAILS_PORT} ] || [ -z ${NGINX_PORT} ] || [ -z ${APP_NAME} ];then
  echo "USAGE: $0 <Rails port no> <Nginx port> <Application name>"
  echo "Example: $0 3003 83 dbaexpert"
  exit 0
fi

. ~/.bashrc

APP_DIR=/vagrant/shared/${APP_NAME}
NGINX_TEMPLATE_FILE=templates/app-nginx.conf
NGINX_CONFIG_FILE=${APP_DIR}/config/${APP_NAME}-nginx.conf

if [ ! -f ${NGINX_CONFIG_FILE} ];then
  cp ${NGINX_TEMPLATE_FILE} ${NGINX_CONFIG_FILE}
  sed -i "s/<<APPNAME>>/${APP_NAME}/" ${NGINX_CONFIG_FILE}
  sed -i "s/<<RAILS_PORT>>/${RAILS_PORT}/" ${NGINX_CONFIG_FILE}
  sed -i "s/<<NGINX_PORT>>/${NGINX_PORT}/" ${NGINX_CONFIG_FILE}
fi

if [ ! -f /usr/bin/nginx ];then
  echo "Installing nginx package"
  sudo yum install -y epel-release
  sudo yum install -y nginx
fi

if [ ! -f /etc/nginx/conf.d/${NGINX_CONFIG_FILE} ];then
  sudo ln -s ${NGINX_CONFIG_FILE} /etc/nginx/conf.d/${NGINX_CONFIG_FILE}
fi

sudo service nginx stop
sudo service nginx start

exit 0
