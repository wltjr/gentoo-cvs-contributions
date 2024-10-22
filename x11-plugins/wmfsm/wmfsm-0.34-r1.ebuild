# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmfsm/wmfsm-0.34-r1.ebuild,v 1.7 2008/06/29 14:07:56 drac Exp $

inherit eutils

IUSE=""
DESCRIPTION="dockapp for monitoring filesystem usage"
HOMEPAGE="http://www.cs.ubc.ca/~cmg/"
SRC_URI="http://www.cs.ubc.ca/~cmg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc amd64 ppc"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	cd "${S}"/wmfsm
	epatch "${FILESDIR}"/${P}.linux-fs.patch
}

src_install() {
	einstall || die "make install failed"
	dodoc AUTHORS ChangeLog
}
