# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ps2eps/ps2eps-1.64.ebuild,v 1.14 2008/05/12 18:49:52 nixnut Exp $

inherit toolchain-funcs

DESCRIPTION="Tool for generating Encapsulated Postscript Format (EPS,EPSF) files from one-page Postscript documents"
HOMEPAGE="http://www.tm.uka.de/~bless/ps2eps"
SRC_URI="http://www.tm.uka.de/~bless/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="virtual/ghostscript
	!<app-text/texlive-core-2007-r7"

S="${WORKDIR}/${PN}"

src_compile() {
	tc-export CC
	cd "${S}/src/C"
	echo "all: bbox" > Makefile
	emake || die "making bbox failed"
}

src_install() {
	dobin "${S}/src/C/bbox"
	dobin "${S}/bin/ps2eps"
	doman "${S}/doc/man/man1/bbox.1"
	doman "${S}/doc/man/man1/ps2eps.1"

	dodoc Changes.txt README.txt
	dohtml "${S}/doc/html/"*
	docinto pdf
	dodoc "${S}/doc/pdf/"*
}
