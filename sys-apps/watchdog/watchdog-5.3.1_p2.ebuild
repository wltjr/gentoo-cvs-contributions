# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/watchdog/watchdog-5.3.1_p2.ebuild,v 1.3 2007/07/12 05:10:21 mr_bones_ Exp $

inherit eutils

MY_P=${PN}_${PV/_p*/}
S="${WORKDIR}"/${P/_p*/}
PATCH_LEVEL=${PV##*_p}

DESCRIPTION="A software watchdog"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/system/daemons/watchdog/"
SRC_URI="mirror://debian/pool/main/w/watchdog/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/w/watchdog/${MY_P}-${PATCH_LEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~mips ~ppc ~s390 ~sh ~x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${PN}-5.2.6-sundries.patch
	epatch "${FILESDIR}"/${PN}-5.2.6-headers.patch
	epatch "${FILESDIR}"/${PN}-5.2.6-uclibc.patch
	epatch "${WORKDIR}"/${MY_P}-${PATCH_LEVEL}.diff
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	newconfd "${FILESDIR}"/${PN}-conf.d ${PN}
	newinitd "${FILESDIR}"/${PN}-init.d ${PN}

	dodoc AUTHORS README TODO
	docinto examples
	dodoc examples/*
}
