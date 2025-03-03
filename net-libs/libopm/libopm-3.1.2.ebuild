# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libopm/libopm-3.1.2.ebuild,v 1.4 2005/05/10 11:31:07 dholm Exp $

DESCRIPTION="Blitzed Open Proxy Monitor Library"
HOMEPAGE="http://www.blitzed.org/bopm/"
SRC_URI="http://static.blitzed.org/www.blitzed.org/bopm/files/bopm-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="doc"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/bopm-${PV}/src/libopm"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"

	if use doc ; then
		cd doc
		doxygen
	fi
}

src_install() {
	make install DESTDIR=${D} || die "install failed"

	dodoc doc/libopm-api.txt ChangeLog LICENSE
	use doc && dohtml doc/api/*
}
