# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eb/eb-4.2.1.ebuild,v 1.7 2007/03/03 22:40:11 genone Exp $

inherit eutils

IUSE="nls ipv6 threads"

DESCRIPTION="EB is a C library and utilities for accessing CD-ROM books"
HOMEPAGE="http://www.sra.co.jp/people/m-kasahr/eb/"
SRC_URI="ftp://ftp.sra.co.jp/pub/misc/eb/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ~ppc64 x86"

DEPEND="virtual/libc
	sys-libs/zlib
	nls? ( sys-devel/gettext )"

src_compile () {
	econf \
		--with-pkgdocdir=/usr/share/doc/${PF}/html \
		`use_enable nls` \
		`use_enable threads pthread` \
		`use_enable ipv6` || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS INSTALL* NEWS README*
}

pkg_postinst() {
	elog
	elog "If you are upgrading from <app-dicts/eb-4,"
	elog "you may need to rebuild applications depending on eb."
	elog
}
