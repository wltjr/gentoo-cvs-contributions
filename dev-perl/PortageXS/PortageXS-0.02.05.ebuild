# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PortageXS/PortageXS-0.02.05.ebuild,v 1.8 2008/08/02 20:17:02 tove Exp $

inherit perl-module
DESCRIPTION="Portage abstraction layer for perl"
HOMEPAGE="http://download.iansview.com/gentoo/tools/PortageXS/"
SRC_URI="http://download.iansview.com/gentoo/tools/PortageXS/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE="minimal"
SRC_TEST="do"

DEPEND="dev-lang/perl
	dev-perl/Term-ANSIColor
	!minimal? ( dev-perl/IO-Socket-SSL
				virtual/perl-Sys-Syslog )"

src_unpack() {
	unpack ${A}
	if use minimal ; then
		rm -r ${S}/usr
		rm -r ${S}/etc/init.d
		rm -r ${S}/etc/pxs/certs
		rm ${S}/etc/pxs/portagexsd.conf
		rm -r ${S}/lib/PortageXS/examples
	fi
}

pkg_preinst() {
	if use !minimal ; then
		cp -r ${S}/usr ${D}
	fi
	cp -r ${S}/etc ${D}
}

pkg_postinst() {
	if [ -d /etc/portagexs ]; then
		elog "/etc/portagexs has been moved to /etc/pxs for convenience. It is safe"
		elog "to delete old /etc/portagexs directories."
	fi
}
