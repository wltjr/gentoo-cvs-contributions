# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/skyutils/skyutils-2.8-r2.ebuild,v 1.1 2008/07/18 06:02:14 mrness Exp $

inherit flag-o-matic autotools

DESCRIPTION="Library of assorted C utility functions."
HOMEPAGE="None available" # was "http://zekiller.skytech.org/coders_en.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-libs.patch
	eautoreconf
}

src_compile() {
	append-flags -D_GNU_SOURCE
	econf `use_enable ssl` || die "./configure failed"
	emake || die "make failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog
}
