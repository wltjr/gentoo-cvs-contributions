# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios/nagios-3.0.3.ebuild,v 1.1 2008/06/25 18:40:41 dertobi123 Exp $

DESCRIPTION="The Nagios metapackage - merge this to pull install all of the
nagios packages"
HOMEPAGE="http://www.nagios.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="~net-analyzer/nagios-core-${PV}
	>=net-analyzer/nagios-plugins-1.4.12-r100
	>=net-analyzer/nagios-imagepack-1.0-r100"

pkg_setup() {
	# Avoid upgrading from Nagios <3 as the directory structure has changed
	if [[ -f /var/lib/init.d/started/nagios ]] ; then
		if has_version '<net-analyzer/nagios-3.0' ; then
			if [[ "${FORCE_UPGRADE}" ]] ; then
				echo
				ewarn "you are upgrading from an incompatible version and have"
				ewarn "FORCE_UPGRADE set, will build this package while Nagios is running."
				echo
			else
				echo
				eerror "You are upgrading from an incompatible version."
				eerror "Please be advised that installation paths have changed to a more FHS"
				eerror "compliant structure and you won't be able to easily upgrade to"
				eerror "Nagios 3 therefore. You will have to change your configuration"
				eerror "to reflect this change, for example Nagios plugins are now installed"
				eerror "into /usr/$(get_libdir)/nagios/plugins/ instead of /usr/nagios/libexec."
				echo
				eerror "If you want to upgrade now, emerge nagios with:"
				eerror "    FORCE_UPGRADE=1 emerge nagios"
				die "Upgrading from an incompatible version!"
				echo
			fi
		fi
	fi
}

pkg_postrm() {
	elog "Note: this is a META ebuild for ${P}."
	elog "to remove it completely or before re-emerging"
	elog "either use 'depclean', or remove/re-emerge these packages:"
	elog
	for dep in ${RDEPEND}; do
		elog "     ${dep}"
	done
	echo
}
