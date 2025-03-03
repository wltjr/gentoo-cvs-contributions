# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/tux/tux-3.2.16-r1.ebuild,v 1.4 2007/04/22 12:09:38 bangert Exp $

inherit eutils

DESCRIPTION="kernel level httpd"
HOMEPAGE="http://people.redhat.com/mingo/TUX-patches/"
SRC_URI="http://people.redhat.com/mingo/TUX-patches/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2
	dev-libs/popt"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-text/docbook-sgml-utils )"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i "s:-g -fomit-frame-pointer -O2:${CFLAGS}:" Makefile
	use doc || echo "all:" > docs/Makefile
	epatch ${FILESDIR}/${PV}-gcc34.patch
	epatch ${FILESDIR}/${PV}-glibc.patch
}

src_compile() {
	emake || die
}

src_install() {
	make install TOPDIR=${D} || die
	rm -rf ${D}/etc/{rc.d,sysconfig} ${D}/var/tux
	newinitd ${FILESDIR}/tux.init.d tux
	newconfd ${FILESDIR}/tux.conf.d tux

	dodoc NEWS SUCCESS tux.README docs/*.txt
	docinto samples
	dodoc samples/* demo*.c
}
