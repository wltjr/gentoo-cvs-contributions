# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnet/libnet-1.0.2a-r3.ebuild,v 1.17 2007/05/08 22:53:37 genone Exp $

inherit eutils

DESCRIPTION="library to provide an API for commonly used low-level network functions (mainly packet injection)"
HOMEPAGE="http://www.packetfactory.net/libnet/"
SRC_URI="http://www.packetfactory.net/libnet/dist/deprecated/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="1.0"
KEYWORDS="alpha amd64 ~hppa ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}/Libnet-${PV}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/libnet-gcc33-fix
	epatch "${FILESDIR}"/${PV}-slot.patch
	cd "${S}"
	mv libnet-config.in libnet-${SLOT}-config.in || die "moving libnet-config"
	cd "${S}"/include
	ln -s libnet.h libnet-${SLOT}.h
	cd libnet
	for f in *.h ; do
		ln -s ${f} ${f/-/-${SLOT}-} || die "linking ${f}"
	done
	cd "${S}"/doc
	ln -s libnet.3 libnet-${SLOT}.3 || die "linking manpage"
	cd "${S}"
	autoconf || die
}

src_compile() {
	econf || die
	emake CFLAGS="${CFLAGS}" || die "Failed to compile"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	doman "${D}"/usr/man/man3/libnet-1.0.3
	rm -r "${D}"/usr/man

	dodoc VERSION doc/{README,TODO*,CHANGELOG*}
	newdoc README README.1st
	docinto example ; dodoc example/libnet*
	docinto Ancillary ; dodoc doc/Ancillary/*
}

pkg_postinst(){
	elog "libnet ${SLOT} is deprecated !"
	elog "config script: libnet-${SLOT}-config"
	elog "manpage: libnet-${SLOT}"
	elog "library: libnet-${SLOT}.a"
	elog "include: libnet-${SLOT}.h"
}
