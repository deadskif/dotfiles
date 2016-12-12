# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
alias ls='ls -hF --color=auto'
alias l1='ls -1'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias man="LC_ALL="ru_RU.UTF-8" man"
alias hrepn="grep -HRn"

alias udmountb='udisksctl mount -b'
udmountl () {
    local label="$1"
    shift
    udisksctl mount -b /dev/disk/by-label/"${label}" "$@"
}

# From LOR
alias weather='lynx --dump http://weather.noaa.gov/weather/current/UUDD.html | sed -n "/Temperature/s/[0-9][0-9]\? F (//p; /Humidity/p" | tr -d ")"'


PS1='\[\033[01;32m\]\u@\h\[\e[01;33m\][\j]\[\033[01;34m\]\w\[\e[01;32m\]\$\[\033[00m\] '

if [ "${PATH}" = "${PATH%%:${HOME}/bin}" ]; then
	export PATH="${PATH}:${HOME}/bin"
fi

# append to history file instead of overwriting it when shell exits
shopt -s histappend 2> /dev/null

# treat directory paths as arguments to an implicit cd command
shopt -s autocd 2> /dev/null

# the number of commands to remember in the command history
export HISTSIZE='100000'

# don't save duplicates, l, ll, ls, bf, bg, su and exit commands to command
# history
export HISTIGNORE='&:l:ll:ls:[bf]g:su:exit'

# remove all previous lines matching the current line from the history list
# before that line is saved
export HISTCONTROL='erasedups'
#export PP="10$PP"
export MOUNT="/run/media/${USER}"

