# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sweep/sweep-0.9.3.ebuild,v 1.5 2008/04/14 20:16:52 maekke Exp $

inherit eutils autotools

DESCRIPTION="Audio editor and live playback tool"
HOMEPAGE="http://www.metadecks.org/software/sweep/"
SRC_URI="mirror://sourceforge/sweep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="alsa ladspa vorbis mp3 libsamplerate speex"

RDEPEND=">=media-libs/libsndfile-1.0
	>=x11-libs/gtk+-2.4.0
	>=dev-libs/glib-2.2.0
	alsa? ( media-libs/alsa-lib )
	libsamplerate? ( media-libs/libsamplerate )
	speex? ( media-libs/speex )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	mp3? ( media-libs/libmad )
	ladspa? ( media-libs/ladspa-sdk )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

LANGS="de el es_ES fr hu it ja pl ru"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X}"
done

src_compile() {
	econf $(use_enable vorbis oggvorbis) \
		$(use_enable mp3 mad) \
		$(use_enable speex) \
		$(use_enable libsamplerate src) \
		$(use_enable alsa)
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
