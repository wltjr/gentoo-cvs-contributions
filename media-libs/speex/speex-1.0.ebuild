# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/speex/speex-1.0.ebuild,v 1.6 2003/10/04 23:50:36 brad_mssw Exp $

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Speex - Speech encoding library"
HOMEPAGE="http://www.speex.org"
SRC_URI="http://www.speex.org/download/${MY_P}.tar.gz"
SLOT="0"
LICENSE="BSD as-is"
KEYWORDS="x86 ppc ~sparc ~amd64"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	einstall || die
	rm -rf ${D}/usr/share/doc/*

	insinto /usr/share/doc/${P}
	doins ${S}/doc/manual.pdf
	dodoc AUTHORS ChangeLog README TODO NEWS
}
