# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-admin/files/rc-addon.sh,v 1.1 2006/03/15 18:13:03 hd_brummy Exp $
#
# rc-addon-script for plugin admin
#
# Joerg Bornkessel <hd_brummy@gentoo.org>
#

# Location for all plugin config files
: ${ADMIN_CONF_DIR:=/etc/vdr/plugins/admin}

# Location of the script files
: ${ADMIN_SCRIPT_PATH:=/etc/vdr/plugins/admin}

# Location of the config file
: ${ADMIN_CFG_FILE:=${ADMIN_SCRIPT_PATH}/admin.conf}

# Location of the config file
: ${ADMIN_EXEC_SCRIPT:=${ADMIN_SCRIPT_PATH}/~admexec}

# Location of the log file
: ${ADMIN_LOG_FILE:=/var/log/vdradmplg.log}

# GETVAl and SETVAL scripts
: ${GETVAL:=${ADMIN_SCRIPT_PATH}/getadmval.sh}
: ${SETVAL=${ADMIN_SCRIPT_PATH}/setadmval.sh}

plugin_pre_vdr_start() {

add_plugin_param "-d ${ADMIN_CONF_DIR}"

}

# for compatibility
if [[ ${SCRIPT_API:-1} -lt 2 ]]; then
plugin_pre_vdr_start
fi
						 