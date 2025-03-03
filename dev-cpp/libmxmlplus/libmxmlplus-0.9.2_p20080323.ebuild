# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libmxmlplus/libmxmlplus-0.9.2_p20080323.ebuild,v 1.1 2008/03/24 20:50:14 dev-zero Exp $

DESCRIPTION="Minimal XML DOM Library"
SRC_URI="mirror://gentoo/${P}.tar.lzma"
HOMEPAGE="http://mxml.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )
	app-arch/lzma-utils"
RDEPEND=""

src_compile() {
	econf \
		--enable-shared \
		$(use_enable doc) \
		--disable-dependency-tracking || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR=${D} install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README RELNOTES TODO

	if use doc; then
		dodir /usr/share/doc/${PF}
		dohtml -r "${S}/doc/html"/*
	fi
}
