# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vcr/vcr-1.09-r1.ebuild,v 1.3 2003/02/13 13:36:28 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="VCR - Linux Console VCR"
SRC_URI="http://www.stack.nl/~brama/${PN}/src/${P}.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2"
HOMEPAGE="http://www.stack.nl/~brama/vcr/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="media-video/avifile"

src_unpack () {
	unpack ${P}.tar.gz
	( bzcat ${DISTDIR}/${P}-gentoo.diff.bz2 | patch -p0 ) || die
}

src_compile () {
	local myconf
	myconf="--enable-avifile-0_6"
	econf ${myconf} || die "econf died"
	emake || die "emake died"
}

src_install () {

	einstall || die "einstall died"
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
