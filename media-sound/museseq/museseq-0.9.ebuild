# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/museseq/museseq-0.9.ebuild,v 1.4 2008/07/27 21:30:21 carlo Exp $

EAPI=1

inherit kde-functions eutils

MY_P=${P/museseq/muse}

DESCRIPTION="MusE is a MIDI/Audio sequencer with recording and editing capabilities"
HOMEPAGE="http://www.muse-sequencer.org"
SRC_URI="mirror://sourceforge/lmuse/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc lash debug"

RDEPEND="x11-libs/qt:3
	>=media-libs/alsa-lib-0.9.0
	>=media-sound/fluidsynth-1.0.3
	dev-lang/perl
	media-libs/libsndfile
	media-libs/libsamplerate
	>=media-sound/jack-audio-connection-kit-0.98.0
	lash? ( media-sound/lash )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-text/openjade
		app-doc/doxygen
		media-gfx/graphviz )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	EPATCH_SUFFIX="patch" epatch "${FILESDIR}"/${PV}
}

src_compile() {
	econf --disable-suid-build --disable-optimize \
		$(use_enable lash) $(use_enable debug) \
		|| die "econf failed."

	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README* SECURITY
	mv "${D}"/usr/bin/muse "${D}"/usr/bin/museseq
}

pkg_postinst() {
	elog "You must have the realtime module loaded to use MuSe.."
	elog "Additionally, configure your Linux Kernel for non-generic"
	elog "Real Time Clock support enabled or loaded as a module."
	elog "User must have read/write access to /dev/misc/rtc device."
	elog "Realtime LSM: http://www.gentoo.org/proj/en/desktop/sound/realtime.xml"
}
