# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcp/wmcp-1.2.8.ebuild,v 1.17 2008/01/06 14:28:56 drac Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="A pager dockapp"
HOMEPAGE="http://www.dockapps.com/file.php/id/158"
SRC_URI="http://linux-sea.tucows.webusenet.com/files/x11/dock/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc33.patch
	epatch "${FILESDIR}"/${P}-stdlibh.patch
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile
}

src_compile() {
	emake -j1 INCLUDES="-I/usr/include/X11" \
		LIBINC="-L/usr/$(get_libdir)" \
		FLAGS="${CFLAGS}" || die "emake failed."
}

src_install() {
	dobin wmcp
	dodoc README
}
