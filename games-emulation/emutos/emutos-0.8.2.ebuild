# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/emutos/emutos-0.8.2.ebuild,v 1.3 2008/02/14 22:46:37 nyhm Exp $

inherit games

DESCRIPTION="a single-user single-tasking operating system for 32 bit Atari computer emulators"
HOMEPAGE="http://emutos.sourceforge.net"
SRC_URI="mirror://sourceforge/emutos/emutos-512k-${PV}.zip
	mirror://sourceforge/emutos/emutos-256k-${PV}.zip
	mirror://sourceforge/emutos/emutos-192k-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	dogameslib */*.img || die "dogameslib failed"
	dodoc emutos-512k-${PV}/{readme.txt,doc/{announce,authors,changelog,status}.txt}
	prepgamesdirs
}
