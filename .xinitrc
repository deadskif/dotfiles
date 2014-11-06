# the following variable defines the session which is started if the user
# e
# doesn't explicitely select a session
DEFAULT_SESSION=awesome

log () 
{
	logger "$*"
}
XINITENV="/home/skif/.bin/xinit_env.sh"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
logger ".xinitrc started, session is $1"
case "$1" in
awesome|"")
	#exec ck-launch-session awesome
	$XINITENV base
	#exec awesome
	logger "trying to make all fine"
	#exec ck-launch-session dbus-launch awesome
	#exec ck-launch-session dbus-launch awesome 
	#logger "awesome: `ck-launch-session dbus-launch awesome 2>&1`"
	logger "awesome: `dbus-launch --exit-with-session awesome 2>&1`"
	#errmsg="`ck-launch-session dbus-launch awesome 2>&1`"
	logger "ck-launch filed with code $? and errmsg=$errmsg"
	;;
xfce4)
	exec startxfce4
	;;
icewm)
	icewmbg &
	icewmtray &
	exec icewm
	;;
wmaker)
	exec wmaker
	;;
blackbox)
	exec blackbox
	;;
urxvt)
	exec urxvt
	;;
*)
	$XINITENV base
	exec $DEFAULT_SESSION
	;;
esac
