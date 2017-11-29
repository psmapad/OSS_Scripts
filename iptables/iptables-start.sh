#! /bin/bash
### BEGIN INIT INFO
# Provides: iptables
# Required-Start: mountkernfs $local_fs
# Required-Stop: mountkernfs $local_fs
# X-Start-Before: networking
# X-Stop-After: networking
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Iptables
# Description: Debian init script for iptables
### END INIT INFO
# Need to run update-rc.d iptables defaults
# Neet to create iptables-save > /etc/default/iptables
# File to be put on /etc/init.d/

. /lib/lsb/init-functions

function do_start {
if [ -e "/etc/default/iptables" ]; then
    log_daemon_msg "Starting iptables service" "iptables"
    /sbin/iptables-restore < /etc/default/iptables
    log_end_msg $?
else
    log_action_msg "No rules saved for iptables"
fi
}
function do_stop {
    log_daemon_msg "Stopping iptables service" "iptables"
    /sbin/iptables -F
    /sbin/iptables -X
    /sbin/iptables -t nat -F
    /sbin/iptables -t nat -X
    /sbin/iptables -t mangle -F
    /sbin/iptables -t mangle -X
    /sbin/iptables -P INPUT ACCEPT
    /sbin/iptables -P FORWARD ACCEPT
    /sbin/iptables -P OUTPUT ACCEPT
    log_end_msg $?
}
function do_save {
    log_daemon_msg "Saving iptables rules" "iptables"
    /sbin/iptables-save > /etc/default/iptables
    log_end_msg $?
}
case "$1" in
    start)
	do_start
	;;
    stop)
	do_stop
	;;
    save)
	do_save
	;;
    restart)
	do_stop
	do_start
	;;
    *)
	echo "Usage: /etc/init.d/iptables {start|stop|restart|save}"
	exit 1
	;;
esac
exit 0

