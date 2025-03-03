# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/portaudio/portaudio-19_pre20071207.ebuild,v 1.11 2008/06/24 20:55:31 drac Exp $

EAPI=1

MY_P=pa_stable_v${PV/pre}

DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com"
SRC_URI="http://www.portaudio.com/archives/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="alsa +cxx debug jack oss"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.109.2-r1 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

src_compile() {
	econf $(use_enable cxx) $(use_with jack) $(use_with alsa) \
		$(use_with oss) $(use_with debug debug-output)

	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc V19-devel-readme.txt
	dohtml index.html
}
