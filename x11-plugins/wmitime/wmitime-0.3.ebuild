# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmitime/wmitime-0.3.ebuild,v 1.17 2008/06/29 13:55:57 drac Exp $

inherit eutils

S=${WORKDIR}/${PN}
IUSE=""
DESCRIPTION="Overglorified clock dockapp w/time, date, and internet time"
HOMEPAGE="http://www.neotokyo.org/illusion/"
SRC_URI="http://www.neotokyo.org/illusion/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc ppc64 ~sparc"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/makefile.diff
}

src_compile() {
	cd "${S}"/wmitime
	make || die "make failed"
}

src_install() {
	cd "${S}"/wmitime
	dobin wmitime

	cd "${S}"
	dodoc BUGS CHANGES README
}
