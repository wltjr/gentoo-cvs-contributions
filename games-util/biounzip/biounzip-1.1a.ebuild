# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/biounzip/biounzip-1.1a.ebuild,v 1.6 2008/05/15 13:16:53 nyhm Exp $

inherit eutils

DESCRIPTION="Unpacks BioZip archives"
HOMEPAGE="http://biounzip.sourceforge.net/"
SRC_URI="mirror://sourceforge/biounzip/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/zlib"

S=${WORKDIR}/${P/a/}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-64bit.patch
}

src_compile() {
	sed -i -e "s#-march=athlon-xp#${CFLAGS}#" Makefile || die
	emake || die
}

src_install() {
	dobin biounzip || die
	dodoc biozip.txt
}
