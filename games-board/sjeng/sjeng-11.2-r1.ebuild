# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/sjeng/sjeng-11.2-r1.ebuild,v 1.5 2005/05/04 21:34:37 mr_bones_ Exp $

inherit games

DESCRIPTION="Console based chess interface"
HOMEPAGE="http://sjeng.sourceforge.net/"
SRC_URI="mirror://sourceforge/sjeng/Sjeng-Free-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
SLOT="0"
IUSE=""

DEPEND="sys-libs/gdbm"

S=${WORKDIR}/Sjeng-Free-${PV}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS
	prepgamesdirs
}
