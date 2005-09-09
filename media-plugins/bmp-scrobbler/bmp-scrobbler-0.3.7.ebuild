# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/bmp-scrobbler/bmp-scrobbler-0.3.7.ebuild,v 1.3 2005/09/09 11:27:59 flameeyes Exp $

IUSE="debug"

DESCRIPTION="Audioscrobbler music-profiling plugin for Beep Media Player"
HOMEPAGE="http://www.audioscrobbler.com/"
MY_P=${P/bmp/xmms}
SRC_URI="http://static.audioscrobbler.com/plugins/${MY_P}.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="media-sound/beep-media-player
	net-misc/curl
	>=media-libs/musicbrainz-2.0.2-r2"

src_compile() {
	if ! useq debug; then
		sed -i 's:-DDEBUG=1:-DDEBUG=0:' Makefile.*
		sed -i 's:-DMETA_DEBUG=1:-DMETA_DEBUG=0:' Makefile.*
		sed -i 's:^[ \t]*printf::' scrobbler.c
	fi
	econf '--disable-xmms-plugin' || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
