# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/poa/poa-2.ebuild,v 1.1 2006/10/21 06:31:50 dberkholz Exp $

inherit eutils

MY_P="${PN}V${PV}"
DESCRIPTION="Fast multiple sequence alignments using partial-order graphs"
HOMEPAGE="http://www.bioinformatics.ucla.edu/poa/"
SRC_URI="mirror://sourceforge/poamsa/${MY_P}.tar.gz"
# According to SF project page
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/respect-cflags.patch
}

src_compile() {
	emake \
		OPT_CFLAGS="${CFLAGS}" \
		poa \
		|| die "make failed"
}

src_install() {
	exeinto /usr/bin
	doexe "${S}"/poa "${S}"/make_pscores.pl
	dolib.a "${S}"/liblpo.a
	dodoc "${S}"/README "${S}"/multidom.*
	insinto /usr/share/poa
	doins "${S}"/*.mat
}

pkg_postinst() {
	elog "poa requires a score matrix as the first argument."
	elog "This package installs two examples to ${ROOT}usr/share/poa/."
}
