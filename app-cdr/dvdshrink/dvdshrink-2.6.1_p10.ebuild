# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/dvdshrink/dvdshrink-2.6.1_p10.ebuild,v 1.2 2008/06/09 20:09:57 drac Exp $

inherit eutils

DESCRIPTION="Scriptable DVD copy software"
HOMEPAGE="http://dvdshrink.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P/_p/-}mdk.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk"

RDEPEND=">=media-video/transcode-1.0.2-r2
	>=media-video/mjpegtools-1.8.0-r1
	>=media-video/subtitleripper-0.3.4-r1
	>=media-video/dvdauthor-0.6.11
	>=app-cdr/dvd+rw-tools-6.1
	gtk? ( >=dev-perl/gtk2-perl-1.104 )
	>=app-text/gocr-0.40
	virtual/cdrtools"
DEPEND=""

S=${WORKDIR}/${PN}

pkg_setup() {
	if ! built_with_use media-video/transcode dvdread; then
		eerror "Please re-emerge transcode with the dvdread USE flag."
		die  "transcode needs dvdread support"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e 's:applications/::g' -i usr/bin/dvdsfunctions \
		-i usr/bin/xdvdshrink.pl || die "sed failed."
}

src_install() {
	dobin usr/bin/{batchrip.sh,dvds{functions,hrink}} || die "dobin failed."

	if use gtk; then
		dobin usr/bin/xdvdshrink.pl || die "dobin failed."
	fi

	insinto /usr/share
	doins -r usr/share/applications/dvdshrink || die "doins failed."

	dodoc usr/share/doc/dvdshrink/{batchrip.txt,example.xml,README.txt}

	doicon usr/share/icons/{batchrip.xpm,dvdshrink.xpm}
	use gtk && make_desktop_entry xdvdshrink.pl xDVDShrink ${PN} AudioVideo
}
