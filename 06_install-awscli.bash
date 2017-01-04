#!/bin/bash

function log_entry {
  MESG=$1

  echo "`hostname`:`date`: ${MESG}" | tee -a ${LOG_FILE}
}

function check_ntpd {
  typeset -i NTP_INSTALLED=$(rpm -qa | grep ntpd | grep -v ntpdate | wc -l)

  if [ ${NTP_INSTALLED} -le 0 ];then
    log_entry "ntpd is not installed. Installing it now"
    yum install ntpdate ntp -y
  else
    log_entry "ntpd is already installed."
  fi

  typeset -i NTP_CONFIGURED=$(/sbin/chkconfig | grep 'ntpd ' | grep on | wc -l)
  if [ ${NTP_CONFIGURED} -le 0 ];then
    log_entry "ntpd is not configured to start. Doing it now"
    chkconfig ntpd on
  else
    log_entry "ntpd is already configured to start."
  fi

  typeset -i NTP_STARTED=$(service ntpd status | grep stopped | wc -l) 
  if [ ${NTP_STARTED} -ge 1 ];then
    log_entry "ntpd is not started. Starting it now"
    service ntpd start
  else
    log_entry "ntpd is already started."
  fi
}

if [ "x`id -nu`x" != "xrootx" ];then
  log_entry "ERROR: Script needs to be run under 'root'. You are running it under '`id -nu`' id"
  exit 1
fi

which aws >/dev/null 2>&1
typeset -i status=$?
if [ ${status} -eq 0 ];then
  log_entry "AWS CLI is installed"
else
  yum install -y python-devel 
  log_entry "AWS CLI is not installed. Installing it now"
  cd /tmp
  curl -O https://bootstrap.pypa.io/get-pip.py 
  sudo python get-pip.py
  sudo pip install awscli
fi

if [ ! -f ~/.aws/credentials ];then
  log_entry "AWS is not configured. Going to try configure it"
  aws configure
else
  log_entry "AWS is configured"
fi
if [ ! -f ~/.aws/credentials ];then
  exit 1
fi

which aws >/dev/null 2>&1
typeset -i status=$?
if [ ${status} -ne 0 ];then
  exit 1
fi

check_ntpd

exit 0
