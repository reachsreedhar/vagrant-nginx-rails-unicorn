#!/bin/bash

function create_ssh_tunnel_for_db {
  SSH_TUNNEL_PORT=3365
  SSH_TUNNEL_HOST=127.0.0.1
  REMOTE_DB_LISTENER_PORT=1521
  REMOTE_DB_HOST=manta

  TUNNEL_FOUND=$(ps -ef | grep ssh | grep "${SSH_TUNNEL_PORT}:${SSH_TUNNEL_HOST}:${REMOTE_DB_LISTENER_PORT}" | wc -l)
  echo "Tunnel found : <${TUNNEL_FOUND}>"

  if [ ${TUNNEL_FOUND} -ge 1 ];then
    echo "ssh tunnel for DB connection already up"
  else
    echo "Creating ssh tunnel for DB connection"
    echo "  ssh tunnel port         : <${SSH_TUNNEL_PORT}>"
    echo "  ssh tunnel host         : <${SSH_TUNNEL_HOST}>"
    echo "  Remote DB host          : <${REMOTE_DB_HOST}>"
    echo "  Remote DB listener port : <${REMOTE_DB_LISTENER_PORT}>"
    ssh -f -N -L ${SSH_TUNNEL_PORT}:${SSH_TUNNEL_HOST}:${REMOTE_DB_LISTENER_PORT} ${REMOTE_DB_HOST}
    sed -i "s/<dbhost>/${SSH_TUNNEL_HOST}/" ${RAILS_DB_CONFIG_FILE}
    sed -i "s/<port>/${SSH_TUNNEL_PORT}/" ${RAILS_DB_CONFIG_FILE}
    sed -i "s/<sid>/${ORACLE_SID}/" ${RAILS_DB_CONFIG_FILE}
    sed -i "s/<user>/${DB_USERNAME}/" ${RAILS_DB_CONFIG_FILE}
    sed -i "s/<pwd>/${DB_PASSWORD}/" ${RAILS_DB_CONFIG_FILE}
  fi

  TUNNEL_FOUND=$(ps -ef | grep ssh | grep "${SSH_TUNNEL_PORT}:${SSH_TUNNEL_HOST}:${REMOTE_DB_LISTENER_PORT}" | wc -l)
  echo "Tunnel found : <${TUNNEL_FOUND}>"
  if [ ${TUNNEL_FOUND} -le 0 ];then
    echo "ERROR: Could not create ssh tunnel for DB connection"
    exit 1
  fi
}

export RAILS_PORT=$1
export APP_NAME=$2
export ORACLE_SID=$3

if [ -z ${RAILS_PORT} ] || [ -z ${APP_NAME} ] || [ -z ${ORACLE_SID} ];then
  echo "USAGE: $0 <Rails port no> <Application name> <Oracle SID>"
  echo "Example: $0 3003 dbaexpert dcap"
  exit 0
fi

. ~/.bashrc

if [ -z ${DB_USERNAME} ] || [ -z ${DB_PASSWORD} ];then
  echo "ERROR: Required DB_USERNAME and DB_PASSWORD entries missing in .bashrc. Please add them and retry"
  exit 1
fi
APP_ROOT=/vagrant/shared
RAILS_DB_CONFIG_FILE=${APP_ROOT}/${APP_NAME}/config/database.yml

ORACLI_TGZ=${APP_ROOT}/oracle_11.2.0.4_client.tgz
if [ ! -f ${ORACLI_TGZ} ];then
  if [ ! -f ~/.aws/credentials ];then
    echo "AWS is not configured. Going to try configure it"
    aws configure
  fi
  aws s3 cp s3://capterra-development/oracle/oracle_11.2.0.4_client.tgz ${ORACLI_TGZ}
fi
if [ ! -f ${ORACLI_TGZ} ];then
  echo "ERROR: Could not download ${ORACLI_TGZ} from AWS S3"
  exit 1
fi
if [ ! -d ${APP_ROOT}/oracle ];then
  cd ${APP_ROOT}
  tar -zxvf ${ORACLI_TGZ}
fi

if [ ! -f ${APP_ROOT}/.ruby-version ];then
  cp templates/.ruby-version ${APP_ROOT}
fi

pwd
cd ${APP_ROOT}
cd -
which ruby
STAT=$?
echo "STAT: <${STAT}>"
if [ ${STAT} -eq 1 ];then
  echo "ERROR: Ruby exec not found!"
  exit 1
fi

APP_DIR=${APP_ROOT}/${APP_NAME}

if [ ! -f ~vagrant/.gemrc ];then
  cp templates/gemrc ~vagrant/.gemrc
fi

cd templates
gem install bundler
bundle 
cd -
cd ${APP_ROOT}
echo "pwd=<$(pwd)>"
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

create_ssh_tunnel_for_db

echo "Start the webric to test if all ok with Rails app"
cd ${APP_DIR}
rails s -b 0.0.0.0 -p ${RAILS_PORT}
