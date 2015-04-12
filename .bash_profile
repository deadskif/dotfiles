# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc

[ -f "$HOME/.TODO" ] && cat $HOME/.TODO
[ -f "$HOME/.TODO_ONCE" ] && cat $HOME/.TODO_ONCE
[ -f "$HOME/.bash_profile.local" ] && . "$HOME/.bash_profile.local"
