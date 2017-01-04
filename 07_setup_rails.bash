#!/bin/bash

export RAILS_PORT=$1
export APP_NAME=$2

if [ -z ${RAILS_PORT} ] || [ -z ${APP_NAME} ];then
  echo "USAGE: $0 <Rails port no> <Application name>"
  echo "Example: $0 3003 dbaexpert"
  exit 0
fi

. ~/.bashrc

ORACLI_TGZ=/vagrant/shared/oracle_11.2.0.4_client.tgz
if [ ! -f ${ORACLI_TGZ} ];then
  aws s3 cp s3://capterra-development/oracle/oracle_11.2.0.4_client.tgz ${ORACLI_TGZ}
fi
if [ ! -d /vagrant/shared/oracle ];then
  cd /vagrant/shared
  tar -zxvf ${ORACLI_TGZ}
fi

which ruby

APP_DIR=/vagrant/shared/${APP_NAME}

if [ ! -f ~vagrant/.gemrc ];then
  cp templates/gemrc ~vagrant/.gemrc
fi

cd templates
gem install bundler
bundle 
cd -
cd /vagrant/shared
if [ ! -d ${APP_DIR} ];then
  rails new ${APP_NAME} -d oracle
fi
cd -

if [ ! -f ${APP_DIR}/Gemfile.orig ];then
  mv ${APP_DIR}/Gemfile ${APP_DIR}/Gemfile.orig
  cp templates/Gemfile ${APP_DIR}
fi

if [ ! -f ${APP_DIR}/config/database.yml.orig ];then
  mv ${APP_DIR}/config/database.yml ${APP_DIR}/config/database.yml.orig
  cp templates/database.yml ${APP_DIR}/config/.
fi
 
echo "Create the ssh tunnel for DB connection"
ssh -f -N -L 3365:127.0.0.1:1521 manta
echo "Start the webric to test if all ok with Rails app"
cd ${APP_DIR}
rails s -b 0.0.0.0 -p ${RAILS_PORT}
