# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
export PATH=/usr/local/bin:${PATH}
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
