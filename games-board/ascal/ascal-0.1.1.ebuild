# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ascal/ascal-0.1.1.ebuild,v 1.3 2007/06/12 14:57:42 nyhm Exp $

inherit autotools eutils games

DESCRIPTION="A game similar to Draughts but with some really cool enhancements"
HOMEPAGE="http://ascal.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/libgnomecanvasmm
	dev-cpp/libglademm
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-install.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
	prepgamesdirs
}
