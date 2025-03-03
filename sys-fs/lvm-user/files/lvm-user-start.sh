# /lib/rcscripts/addons/lvm-user-start.sh
# $Header: /var/cvsroot/gentoo-x86/sys-fs/lvm-user/files/lvm-user-start.sh,v 1.1 2005/02/23 03:47:44 rocket Exp $

# LVM support for /usr, /home, /opt ....
# This should be done *before* checking local
# volumes, or they never get checked.
			        
# NOTE: Add needed modules for LVM or RAID, etc
#       to /etc/modules.autoload if needed
if [ -z "${CDBOOT}" -a -x /sbin/vgscan ] && \
	[ -d /proc/lvm -o "$(grep device-mapper /proc/misc 2>/dev/null)" ]
then
	ebegin "Setting up the Logical Volume Manager"
	#still echo stderr for debugging
	/sbin/vgscan >/dev/null
	if [ "$?" -eq 0 ] && [ -x /sbin/vgchange ] && \
		[ -f /etc/lvmtab -o -d /etc/lvm ]
	then
		/sbin/vgchange -a y >/dev/null
	fi
	eend $? "Failed to setup the LVM"
fi

# vim:ts=4
