# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vstrip/vstrip-0.8f.ebuild,v 1.5 2007/06/26 02:19:55 mr_bones_ Exp $

inherit eutils

DESCRIPTION="A program to split non-css dvd vobs into individual chapters"
HOMEPAGE="http://www.maven.de/code"
SRC_URI="http://files.digital-digest.com/downloads/files/encode/vStrip_${PV/./}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gentoo.patch
	edos2unix *.c *.h

	for file in *.c *.h ; do
		echo >>$file
	done
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	dobin vstrip
}
