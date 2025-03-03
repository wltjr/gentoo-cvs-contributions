# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmfortune/wmfortune-0.241.ebuild,v 1.12 2008/01/15 08:35:28 drac Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="a dockapp showing fortune-mod messages."
HOMEPAGE="http://dockapps.org/files/90/128"
SRC_URI="http://www.dockapps.com/download.php/id/128/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="games-misc/fortune-mod
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-stringh.patch
}

src_compile() {
	emake CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}" \
		XLIBDIR="/usr/$(get_libdir)" || die "emake failed."
}

src_install() {
	dobin ${PN}
	dodoc CHANGES README TODO
}
