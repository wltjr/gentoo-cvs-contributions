# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mkvtoolnix/mkvtoolnix-0.8.5.ebuild,v 1.5 2004/08/25 19:48:46 mholzer Exp $

DESCRIPTION="Tools to create, alter, and inspect Matroska files"
HOMEPAGE="http://www.bunkus.org/videotools/mkvtoolnix"
SRC_URI="http://www.bunkus.org/videotools/mkvtoolnix/sources/old/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="X oggvorbis"

DEPEND=">=dev-libs/libebml-0.6.4
	>=media-libs/libmatroska-0.6.3
	oggvorbis? ( media-libs/libogg media-libs/libvorbis media-libs/flac )
	X? ( >=x11-libs/wxGTK-2.4.1 )
	dev-libs/expat
	app-arch/bzip2
	sys-libs/zlib
	dev-libs/lzo"

src_compile() {
	local myconf=""

	use oggvorbis || myconf="${myconf} --disable-oggtest \
		--disable-vorbistest --without-ogg --without-vorbis"
	./configure ${myconf} || die "configure died"

	# v0.7.9 is missing "#include <errno.h>" in some files
	MAKEOPTS="-j1"
	emake CXX="${CXX} -include /usr/include/errno.h -include /usr/include/unistd.h" || die "make failed"
}

src_install() {
	einstall || die "install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	dohtml doc/mkvmerge-gui.html
}
