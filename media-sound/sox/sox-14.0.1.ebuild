# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sox/sox-14.0.1.ebuild,v 1.10 2008/07/07 14:32:22 solar Exp $

inherit flag-o-matic eutils autotools

DESCRIPTION="The swiss army knife of sound processing programs"
HOMEPAGE="http://sox.sourceforge.net"
SRC_URI="mirror://sourceforge/sox/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~arm alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="alsa amrnb amrwb ao debug encode ffmpeg flac id3tag ladspa mad libsamplerate ogg oss sndfile "

DEPEND="alsa? ( media-libs/alsa-lib )
	encode? ( media-sound/lame )
	flac? ( media-libs/flac )
	mad? ( media-libs/libmad )
	sndfile? ( media-libs/libsndfile )
	libsamplerate? ( media-libs/libsamplerate )
	ogg? ( media-libs/libvorbis	media-libs/libogg )
	ao? ( media-libs/libao )
	ffmpeg? ( media-video/ffmpeg )
	ladspa? ( media-libs/ladspa-sdk )
	>=media-sound/gsm-1.0.12-r1
	id3tag? ( media-libs/libid3tag )
	amrnb? ( media-libs/amrnb )
	amrwb? ( media-libs/amrwb )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-ffmpegheaders.patch"
	epatch "${FILESDIR}/${P}-cross.patch"

	AT_M4DIR="m4" eautoreconf
}

src_compile () {
	# Fixes wav segfaults. See Bug #35745.
	append-flags -fsigned-char

	econf $(use_enable alsa) \
		$(use_enable debug) \
		$(use_enable ao libao) \
		$(use_enable oss) \
		$(use_with encode lame) \
		$(use_with mad) \
		$(use_with sndfile) \
		$(use_with flac) \
		$(use_with ogg) \
		$(use_with libsamplerate samplerate) \
		$(use_with ffmpeg) \
		$(use_with ladspa) \
		$(use_with id3tag) \
		$(use_with amrwb amr-wb) \
		$(use_with amrnb amr-nb) \
		--enable-fast-ulaw \
		--enable-fast-alaw \
		|| die "configure failed"

	#workaround for flac, it wants to include a damn config.h file
	touch src/config.h
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc NEWS ChangeLog README AUTHORS
}
