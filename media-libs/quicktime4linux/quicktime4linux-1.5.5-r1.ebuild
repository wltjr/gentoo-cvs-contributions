# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/quicktime4linux/quicktime4linux-1.5.5-r1.ebuild,v 1.15 2004/04/27 22:01:36 agriffis Exp $

inherit eutils

DESCRIPTION="quicktime library for linux"
HOMEPAGE="http://heroinewarrior.com/quicktime.php3"
SRC_URI="http://heroinewarrior.com/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 sparc ppc amd64"

DEPEND="media-libs/jpeg
	media-libs/libpng
	!media-libs/libquicktime"
PROVIDE="virtual/quicktime"

S=${WORKDIR}/quicktime

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	epatch ${FILESDIR}/quicktime_makefile.patch
	epatch ${FILESDIR}/${P}-fPIC.patch
}

src_compile() {
	emake || die
	make util || die
}

src_install() {
	dolib.so `uname -m`/libquicktime.so
	dolib.a  `uname -m`/libquicktime.a
	insinto /usr/include/quicktime
	doins *.h
	dodoc README
	dohtml -r docs
}
