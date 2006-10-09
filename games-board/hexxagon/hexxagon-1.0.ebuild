# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/hexxagon/hexxagon-1.0.ebuild,v 1.6 2006/10/09 14:36:31 nyhm Exp $

inherit eutils games

DESCRIPTION="clone of the original DOS game"
HOMEPAGE="http://nesqi.homeip.net/hexxagon/"
SRC_URI="http://nesqi.homeip.net/hexxagon/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=dev-cpp/glibmm-2.4
	>=dev-cpp/gtkmm-2.4
	>=x11-libs/gtk+-2.0"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon images/board_N_2.xpm ${PN}.xpm
	make_desktop_entry ${PN} Hexxagon ${PN}.xpm
	dodoc README
	prepgamesdirs
}
