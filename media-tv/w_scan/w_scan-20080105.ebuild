# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/w_scan/w_scan-20080105.ebuild,v 1.1 2008/04/02 14:38:55 coldwind Exp $

inherit eutils

DESCRIPTION="Scan for DVB-C/DVB-T channels without prior knowledge of frequencies and modulations - can also create a file in vdr-format"
HOMEPAGE="http://free.pages.at/wirbel4vdr/w_scan/index2.html"
SRC_URI="http://wirbel.htpc-forum.de/w_scan/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-tv/linuxtv-dvb-headers"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-build-and-path-fixes.patch"
	emake clean || die "emake clean failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc README
}
