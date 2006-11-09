# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sam2p/sam2p-0.45.ebuild,v 1.1 2006/11/09 21:32:30 twp Exp $

inherit toolchain-funcs

DESCRIPTION="Utility to convert raster images to EPS, PDF and many others"
HOMEPAGE="http://www.inf.bme.hu/~pts/sam2p/"
# The author refuses to distribute 
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="gif"
DEPEND="dev-lang/perl"
RDEPEND="virtual/libc"

src_compile() {
	local myconf="--enable-lzw `use_enable gif`"
	# Makedep borks if distcc is used, so disable it for econf by
	# overriding the path to g++
	CXX="$(tc-getCXX)" econf ${myconf} || die
	make || die
}

src_install() {
	einstall
	dodoc README
}
