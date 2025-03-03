# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/imlib2/imlib2-1.4.0-r1.ebuild,v 1.8 2008/06/13 22:40:31 vapier Exp $

EKEY_STATE="release"
inherit enlightenment toolchain-funcs

MY_P=${P/_/-}
DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="http://www.enlightenment.org/"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="X bzip2 gif jpeg mmx mp3 png tiff zlib"

DEPEND="=media-libs/freetype-2*
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	gif? ( >=media-libs/giflib-4.1.0 )
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( media-libs/jpeg )
	tiff? ( >=media-libs/tiff-3.5.5 )
	X? ( x11-libs/libXext x11-proto/xextproto )
	mp3? ( media-libs/libid3tag )"

src_unpack() {
	enlightenment_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${P}-CVE-2008-2426.patch #223965
}

src_compile() {
	# imlib2 has diff configure options for x86/amd64 mmx
	local mymmx=""
	if [[ $(tc-arch) == "amd64" ]] ; then
		mymmx="$(use_enable mmx amd64) --disable-mmx"
	else
		mymmx="--disable-amd64 $(use_enable mmx)"
	fi

	export MY_ECONF="
		$(use_with X x) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff) \
		$(use_with gif) \
		$(use_with zlib) \
		$(use_with bzip2) \
		$(use_with mp3 id3) \
		${mymmx} \
	"
	enlightenment_src_compile
}
