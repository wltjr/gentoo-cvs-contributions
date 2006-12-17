# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fox/fox-1.4.34-r1.ebuild,v 1.10 2006/12/17 18:54:50 kloeri Exp $

inherit eutils fox

LICENSE="LGPL-2.1"
SLOT="1.4"
KEYWORDS="alpha amd64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE="bzip2 cups jpeg opengl png threads tiff truetype zlib"

RDEPEND="x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/fox-wrapper
	bzip2? ( >=app-arch/bzip2-1.0.2 )
	cups? ( net-print/cups )
	jpeg? ( >=media-libs/jpeg-6b )
	opengl? ( virtual/opengl virtual/glu )
	png? ( >=media-libs/libpng-1.2.5 )
	tiff? ( >=media-libs/tiff-3.5.7 )
	truetype? ( =media-libs/freetype-2*
		virtual/xft )
	zlib? ( >=sys-libs/zlib-1.1.4 )"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-libs/libXt"

FOXCONF="$(use_enable bzip2 bz2lib) \
	$(use_enable cups) \
	$(use_enable jpeg) \
	$(use_with opengl) \
	$(use_enable png) \
	$(use_enable threads threadsafe) \
	$(use_enable tiff) \
	$(use_with truetype xft) \
	$(use_enable zlib)"

src_unpack() {
	fox_src_unpack
	epatch "${FILESDIR}"/${PV}-gcc4-fix-includes.patch
}
