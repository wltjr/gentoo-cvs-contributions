# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/rubberband/rubberband-1.0.1.ebuild,v 1.1 2008/02/26 22:37:29 aballier Exp $

inherit multilib

DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
HOMEPAGE="http://www.breakfastquay.com/rubberband/"
SRC_URI="http://www.breakfastquay.com/rubberband/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/vamp-plugin-sdk
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/ladspa-sdk
	=sci-libs/fftw-3*"
RDEPEND="${DEPEND}
	dev-util/pkgconfig"

src_install() {
	emake INSTALL_BINDIR="${D}/usr/bin" \
		INSTALL_INCDIR="${D}/usr/include/rubberband" \
		INSTALL_LIBDIR="${D}/usr/$(get_libdir)" \
		INSTALL_VAMPDIR="${D}/usr/$(get_libdir)/vamp" \
		INSTALL_LADSPADIR="${D}/usr/$(get_libdir)/ladspa" \
		INSTALL_PKGDIR="${D}/usr/$(get_libdir)/pkgconfig" \
		install || die "make install failed"
	dodoc README
}
