# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/tap-reverbed/tap-reverbed-0.ebuild,v 1.5 2007/01/05 20:07:29 flameeyes Exp $

IUSE=""

MY_P="${PN}-r0"
DESCRIPTION="Standalone JACK counterpart of LADSPA plugin TAP Reverberator."
HOMEPAGE="http://tap-plugins.sourceforge.net/reverbed.html"
SRC_URI="mirror://sourceforge/tap-plugins/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="media-libs/ladspa-sdk
	media-plugins/tap-plugins
	>=x11-libs/gtk+-2
	media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	einstall

	dodoc README AUTHORS
	insinto /usr/share/tap-reverbed
	insopts -m0666
	doins src/\.reverbed
}

pkg_postinst() {
	elog "TAP Reverb Editor expects the configuration file '.reverbed'"
	elog "to be in the user's home directory.	The default '.reverbed'"
	elog "file can be found in the /usr/share/tap-reverbed directory"
	elog "and should be manually copied to the user's directory."
}
