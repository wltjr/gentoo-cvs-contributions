# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/lsdldoom/lsdldoom-1.4.4.4.ebuild,v 1.2 2003/09/25 22:10:48 zul Exp $

DESCRIPTION="Port of ID's doom to SDL"
SRC_URI="http://www.lbjhs.net/~jessh/lsdldoom/src/${P}.tar.gz
	http://www.lbjhs.net/~jessh/lsdldoom/doom1.wad.gz"
HOMEPAGE="http://firehead.org/~jessh/lsdldoom/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"

DEPEND=">=media-libs/sdl-mixer-1.2.0"

src_unpack() {
	unpack ${P}.tar.gz
	cp ${DISTDIR}/doom1.wad.gz ${S}
	chmod 0644 ${S}/doom1.wad.gz
	gzip -d ${S}/*.gz
}

src_compile() {
	./configure --prefix=/usr --datadir=/usr/share/doom \
	--bindir=/usr/bin --host=${CHOST} || die
	make || die
}

src_install() {
	dobin ${FILESDIR}/lsdldoom
	exeinto /usr/share/doom
	doexe src/lsdldoom src/lxdoom-game-server
	insinto /usr/share/doom/
	doins doom1.wad data/*.wad
	doman doc/boom.cfg.5 doc/lsdldoom.6 doc/lxdoom-game-server.6
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README doc/*.txt
}
