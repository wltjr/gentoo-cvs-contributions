# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/aewm++/aewm++-1.0.24.ebuild,v 1.12 2007/08/02 14:37:26 uberlord Exp $

inherit eutils

DESCRIPTION="A window manager with more modern features than aewm but with the same look and feel."
HOMEPAGE="http://aewmpp.sunsite.dk/"
SRC_URI="mirror://sourceforge/sapphire/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/gcc-3.4.patch"
}

src_compile() {
	make CFLAGS="${CXXFLAGS}" || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog README LICENSE
}
