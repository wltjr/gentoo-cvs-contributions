# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/piozone/piozone-1.0-r2.ebuild,v 1.12 2005/05/29 22:23:53 cryos Exp $

inherit eutils

DESCRIPTION="A hard-disk benchmarking tool."
HOMEPAGE="http://www2.lysator.liu.se/~pen/piozone/"
SRC_URI="ftp://ftp.lysator.liu.se/pub/unix/piozone/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="sys-devel/gcc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff || die
}

src_compile() {
	emake || die
}

src_install() {
	dosbin piozone
}
