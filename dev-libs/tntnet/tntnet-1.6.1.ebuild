# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/tntnet/tntnet-1.6.1.ebuild,v 1.2 2008/01/23 21:29:13 hd_brummy Exp $

DESCRIPTION="A modular, multithreaded webapplicationserver extensible with C++."
HOMEPAGE="http://www.tntnet.org/index.hms"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ssl gnutls examples"

RDEPEND="dev-libs/cxxtools
	sys-libs/zlib
	ssl? (
		gnutls? ( >=net-libs/gnutls-1.2.0 )
		!gnutls? ( dev-libs/openssl )
	)"
DEPEND="${RDEPEND}
	app-arch/zip"

src_compile() {
	local myconf=""
	if use ssl; then
		if use gnutls; then
			einfo "Using gnutls for ssl support."
			myconf="${myconf} --with-ssl=gnutls"
		else
			einfo "Using openssl for ssl support."
			myconf="${myconf} --with-ssl=openssl"
		fi
	else
		einfo "Disabled ssl"
		myconf="${myconf} --with-ssl=no"
	fi
	if use examples; then
		myconf="${myconf} --with-demos=yes"
	else
		myconf="${myconf} --with-demos=no"
	fi

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog README TODO doc/*.pdf

	if use examples; then
		cd "${S}/sdk/demos"
		make clean
		rm -rf .deps */.deps .libs */.libs

		local dir="/usr/share/doc/${PF}/examples"
		dodir "${dir}"
		cp -r "${S}"/sdk/demos/* "${D}${dir}"
	fi
}
