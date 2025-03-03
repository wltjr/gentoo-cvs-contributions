# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/depend.apache.eclass,v 1.44 2008/03/04 10:59:27 hollow Exp $

# @ECLASS: depend.apache.eclass
# @MAINTAINER:
# apache-devs@gentoo.org
# @BLURB: Functions to allow ebuilds to depend on apache
# @DESCRIPTION:
# This eclass handles depending on apache in a sane way and provides information
# about where certain binaries and configuration files are located.
#
# To make use of this eclass simply call one of the need/want_apache functions
# described below. Make sure you use the need/want_apache call after you have
# defined DEPEND and RDEPEND. Also note that you can not rely on the automatic
# RDEPEND=DEPEND that portage does if you use this eclass.
#
# See Bug 107127 for more information.
#
# @EXAMPLE:
#
# Here is an example of an ebuild depending on apache:
#
# @CODE
# DEPEND="virtual/Perl-CGI"
# RDEPEND="${DEPEND}"
# need_apache2
# @CODE
#
# Another example which demonstrates non-standard IUSE options for optional
# apache support:
#
# @CODE
# DEPEND="server? ( virtual/Perl-CGI )"
# RDEPEND="${DEPEND}"
# want_apache2 server
# @CODE

inherit multilib

# ==============================================================================
# INTERNAL VARIABLES
# ==============================================================================

# @ECLASS-VARIABLE: APACHE_VERSION
# @DESCRIPTION:
# Stores the version of apache we are going to be ebuilding.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APXS
# @DESCRIPTION:
# Path to the apxs tool.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APACHE_BIN
# @DESCRIPTION:
# Path to the apache binary.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APACHE_CTL
# @DESCRIPTION:
# Path to the apachectl tool.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APACHE_BASEDIR
# @DESCRIPTION:
# Path to the server root directory.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APACHE_CONFDIR
# @DESCRIPTION:
# Path to the configuration file directory.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APACHE_MODULES_CONFDIR
# @DESCRIPTION:
# Path where module configuration files are kept.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APACHE_VHOSTS_CONFDIR
# @DESCRIPTION:
# Path where virtual host configuration files are kept.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APACHE_MODULESDIR
# @DESCRIPTION:
# Path where we install modules.
# This variable is set by the want/need_apache functions.

# @ECLASS-VARIABLE: APACHE_DEPEND
# @DESCRIPTION:
# Dependencies for Apache
APACHE_DEPEND="www-servers/apache"

# @ECLASS-VARIABLE: APACHE2_DEPEND
# @DESCRIPTION:
# Dependencies for Apache 2.x
APACHE2_DEPEND="=www-servers/apache-2*"

# @ECLASS-VARIABLE: APACHE2_2_DEPEND
# @DESCRIPTION:
# Dependencies for Apache 2.2.x
APACHE2_2_DEPEND="=www-servers/apache-2.2*"

# ==============================================================================
# INTERNAL FUNCTIONS
# ==============================================================================

_init_apache2() {
	debug-print-function $FUNCNAME $*

	# WARNING: Do not use these variables with anything that is put
	# into the dependency cache (DEPEND/RDEPEND/etc)
	APACHE_VERSION="2"
	APXS="/usr/sbin/apxs2"
	APACHE_BIN="/usr/sbin/apache2"
	APACHE_CTL="/usr/sbin/apache2ctl"
	APACHE_INCLUDEDIR="/usr/include/apache2"
	APACHE_BASEDIR="/usr/$(get_libdir)/apache2"
	APACHE_CONFDIR="/etc/apache2"
	APACHE_MODULES_CONFDIR="${APACHE_CONFDIR}/modules.d"
	APACHE_VHOSTS_CONFDIR="${APACHE_CONFDIR}/vhosts.d"
	APACHE_MODULESDIR="${APACHE_BASEDIR}/modules"
}

_init_no_apache() {
	debug-print-function $FUNCNAME $*
	APACHE_VERSION="0"
}

# ==============================================================================
# PUBLIC FUNCTIONS
# ==============================================================================

# @FUNCTION: want_apache
# @USAGE: [myiuse]
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for optional apache
# support. If the myiuse parameter is not given it defaults to apache2.
want_apache() {
	debug-print-function $FUNCNAME $*
	want_apache2 "$@"
}

# @FUNCTION: want_apache2
# @USAGE: [myiuse]
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for optional apache-2.x
# support. If the myiuse parameter is not given it defaults to apache2.
want_apache2() {
	debug-print-function $FUNCNAME $*

	local myiuse=${1:-apache2}
	IUSE="${IUSE} ${myiuse}"
	DEPEND="${DEPEND} ${myiuse}? ( ${APACHE2_DEPEND} )"
	RDEPEND="${RDEPEND} ${myiuse}? ( ${APACHE2_DEPEND} )"

	if use ${myiuse}; then
		_init_apache2
	else
		_init_no_apache
	fi
}

# @FUNCTION: want_apache2_2
# @USAGE: [myiuse]
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for optional
# apache-2.2.x support. If the myiuse parameter is not given it defaults to
# apache2.
want_apache2_2() {
	debug-print-function $FUNCNAME $*

	local myiuse=${1:-apache2}
	IUSE="${IUSE} ${myiuse}"
	DEPEND="${DEPEND} ${myiuse}? ( ${APACHE2_2_DEPEND} )"
	RDEPEND="${RDEPEND} ${myiuse}? ( ${APACHE2_2_DEPEND} )"

	if use ${myiuse}; then
		_init_apache2
	else
		_init_no_apache
	fi
}

# @FUNCTION: need_apache
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for apache.
need_apache() {
	debug-print-function $FUNCNAME $*
	need_apache2
}

# @FUNCTION: need_apache2
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for apache-2.x.
need_apache2() {
	debug-print-function $FUNCNAME $*

	DEPEND="${DEPEND} ${APACHE2_DEPEND}"
	RDEPEND="${RDEPEND} ${APACHE2_DEPEND}"
	_init_apache2
}

# @FUNCTION: need_apache2_2
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for apache-2.2.x.
need_apache2_2() {
	debug-print-function $FUNCNAME $*

	DEPEND="${DEPEND} ${APACHE2_2_DEPEND}"
	RDEPEND="${RDEPEND} ${APACHE2_2_DEPEND}"
	_init_apache2
}

# @FUNCTION: has_apache
# @DESCRIPTION:
# An ebuild calls this to get runtime variables for an indirect apache
# dependency without USE-flag, in which case want_apache does not work.
# DO NOT call this function in global scope.
has_apache() {
	debug-print-function $FUNCNAME $*

	if has_version '>=www-servers/apache-2'; then
		_init_apache2
	else
		_init_no_apache
	fi
}

# @FUNCTION: has_apache_threads
# @USAGE: [myflag]
# @DESCRIPTION:
# An ebuild calls this to make sure thread-safety is enabled if apache has been
# built with a threaded MPM. If the myflag parameter is not given it defaults to
# threads.
has_apache_threads() {
	debug-print-function $FUNCNAME $*

	if ! built_with_use www-servers/apache threads; then
		return
	fi

	local myflag="${1:-threads}"

	if ! use ${myflag}; then
		echo
		eerror "You need to enable USE flag '${myflag}' to build a thread-safe version"
		eerror "of ${CATEGORY}/${PN} for use with www-servers/apache"
		die "Need missing USE flag '${myflag}'"
	fi
}

# @FUNCTION: has_apache_threads_in
# @USAGE: <myforeign> [myflag]
# @DESCRIPTION:
# An ebuild calls this to make sure thread-safety is enabled in a foreign
# package if apache has been built with a threaded MPM. If the myflag parameter
# is not given it defaults to threads.
has_apache_threads_in() {
	debug-print-function $FUNCNAME $*

	if ! built_with_use www-servers/apache threads; then
		return
	fi

	local myforeign="$1"
	local myflag="${2:-threads}"

	if ! built_with_use ${myforeign} ${myflag}; then
		echo
		eerror "You need to enable USE flag '${myflag}' in ${myforeign} to"
		eerror "build a thread-safe version of ${CATEGORY}/${PN} for use"
		eerror "with www-servers/apache"
		die "Need missing USE flag '${myflag}' in ${myforeign}"
	fi
}
