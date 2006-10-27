# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmng/libmng-1.0.9-r1.ebuild,v 1.10 2006/10/27 16:37:03 killerfox Exp $

WANT_AUTOCONF=2.5
WANT_AUTOMAKE=1.9
inherit autotools

DESCRIPTION="Multiple Image Networkgraphics lib (animated png's)"
HOMEPAGE="http://www.libmng.com/"
SRC_URI="mirror://sourceforge/libmng/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ~ppc-macos ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="lcms"

DEPEND=">=media-libs/jpeg-6b
	>=sys-libs/zlib-1.1.4
	lcms? ( >=media-libs/lcms-1.0.8 )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	ln -s makefiles/configure.in .
	ln -s makefiles/Makefile.am .

	eautoreconf
}

src_compile() {
	econf --with-jpeg $(use_with lcms) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc CHANGES README*
	dodoc doc/doc.readme doc/libmng.txt
	doman doc/man/*
}
