# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/spacearyarya-kxl/spacearyarya-kxl-1.0.2-r1.ebuild,v 1.5 2007/03/14 16:23:27 nyhm Exp $

inherit autotools eutils games

MY_P=SpaceAryarya-KXL-${PV}
DESCRIPTION="A 2D/3D shooting game"
HOMEPAGE="http://kxl.orz.hm/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=dev-games/KXL-1.1.4"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gentoo-paths.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon bmp/enemy1.bmp ${PN}.bmp
	make_desktop_entry spacearyarya SpaceAryarya /usr/share/pixmaps/${PN}.bmp
	dodoc ChangeLog README
	prepgamesdirs
}
