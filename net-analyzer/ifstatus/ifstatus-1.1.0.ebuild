# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ifstatus/ifstatus-1.1.0.ebuild,v 1.4 2008/06/28 20:20:16 loki_val Exp $

inherit eutils toolchain-funcs

KEYWORDS="~amd64 ~ppc x86"

DESCRIPTION="A simple CLI program for displaying network statistics in real time."
HOMEPAGE="http://ifstatus.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-v${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=sys-libs/ncurses-4.2"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc43.patch"
	sed -i \
		-e '/^GCC/d' \
		-e '/^CFLAGS/d' \
		-e 's/GCC/CXX/g' \
		-e 's/CFLAGS/CXXFLAGS/g' \
		Makefile || die "sed failed"
}

src_compile() {
	emake -j1 CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin ifstatus
	dodoc AUTHORS README
}

pkg_postinst() {
	elog	"You may want to configure ~/.ifstatus/ifstatus.cfg"
	elog 	"before running ifstatus. For example, you may add"
	elog	"Interfaces = eth0 there. Read the README file for"
	elog	"more information."
}
