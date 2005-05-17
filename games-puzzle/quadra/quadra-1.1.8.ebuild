# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/quadra/quadra-1.1.8.ebuild,v 1.9 2005/05/17 18:40:04 wolf31o2 Exp $

inherit eutils toolchain-funcs games

DESCRIPTION="A tetris clone with multiplayer support"
HOMEPAGE="http://quadra.sourceforge.net/"
SRC_URI="mirror://sourceforge/quadra/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="svga"

RDEPEND="virtual/x11
	>=media-libs/libpng-1.2.1
	sys-libs/zlib
	svga? ( media-libs/svgalib )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	[ $(gcc-major-version) == 3 ] && epatch "${FILESDIR}/${P}-gcc3.patch"
	epatch "${FILESDIR}/libpng-1.2.5.patch"
	use amd64 && epatch "${FILESDIR}/${P}-amd64.patch"
	sed -i \
		-e 's:-pedantic::' config/vars.mk \
			|| die "sed config/vars.mk failed"
	sed -i \
		-e "/^libgamesdir:=/s:/games:/${PN}:" \
		-e "/^datagamesdir:=/s:/games:/${PN}:" config/config.mk.in \
			|| die "sed config/config.mk.in failed"
}

src_compile() {
	egamesconf $(use_with svga svgalib) || die
	emake || die "emake failed"
}

src_install() {
	egamesinstall || die
	doicon "${D}/${GAMES_DATADIR}/pixmaps/quadra.xpm"
	rm -rf "${D}/usr/share/games/pixmaps"

	dodoc ChangeLog NEWS README
	dohtml help/*
	prepgamesdirs
}
