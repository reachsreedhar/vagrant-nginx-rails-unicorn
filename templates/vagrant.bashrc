# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

export ORACLE_HOME=/vagrant/shared/oracle
export LD_LIBRARY_PATH=${ORACLE_HOME}:${LD_LIBRARY_PATH}
export PATH=/vagrant/shared/bin:${ORACLE_HOME}:${PATH}
export TNS_ADMIN=/vagrant/shared/tns

alias r='cd /vagrant/shared/dbaexpert;rails s -b 0.0.0.0 -p 3030'
alias tmanta='ssh -f -N -L 3365:127.0.0.1:1521 manta'
