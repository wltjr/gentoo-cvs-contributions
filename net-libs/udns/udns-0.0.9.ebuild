# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/udns/udns-0.0.9.ebuild,v 1.3 2008/06/11 17:06:52 bluebird Exp $

inherit multilib

DESCRIPTION="Async-capable DNS stub resolver library"
HOMEPAGE="http://www.corpit.ru/mjt/udns.html"
SRC_URI="http://www.corpit.ru/mjt/udns/${P/-/_}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc"
IUSE="ipv6 static"

# Yes, this doesn't depend on any other library beside "system" set
DEPEND=""

src_compile() {

	# Uses non-standard configure script, econf doesn't work
	./configure $(use_enable ipv6) || die "Configure failed"
	emake sharedlib || die "Shared library compilation failed"
	if use static; then
		emake staticlib || die "Static library compilation failed"
	fi

}

src_install() {

	dolib.so libudns.so.0 || die "dolib.so failed"
	dosym libudns.so.0 "/usr/$(get_libdir)/libudns.so" || die "dosym failed"
	if use static; then
		dolib.a libudns.a || die "dolib.a failed"
	fi

	insinto /usr/include
	doins udns.h || die "doins failed"

	doman udns.3 || die "doman failed"
	dodoc TODO NOTES || die "dodoc failed"

}
