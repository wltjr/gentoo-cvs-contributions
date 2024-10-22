# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/djplay/djplay-0.3.0.ebuild,v 1.6 2008/07/27 21:21:45 carlo Exp $

EAPI=1

IUSE=""

inherit eutils qt3

DESCRIPTION="A live DJing application."
HOMEPAGE="http://djplay.sf.net/"
SRC_URI="mirror://sourceforge/djplay/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/alsa-lib
	x11-libs/qt:3
	=dev-libs/glib-1.2*
	media-libs/libsamplerate
	media-libs/libmpeg3
	media-libs/id3lib
	media-libs/libmad
	media-libs/audiofile
	dev-libs/libxml2
	media-plugins/tap-plugins
	media-plugins/swh-plugins
	media-sound/jack-audio-connection-kit
	media-libs/libogg
	media-libs/libvorbis"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s/INCLUDES = -I\$(QTDIR)\/include/INCLUDES = -I\$(QTDIR)\/include -Iplugins\/bitmapbutton -Iplugins\/bitmapslider/" Makefile.am Makefile.in
	rm moc_*.cpp
	epatch "${FILESDIR}/${P}-gcc4.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
