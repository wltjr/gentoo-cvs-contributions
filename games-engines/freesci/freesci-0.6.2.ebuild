# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/freesci/freesci-0.6.2.ebuild,v 1.3 2007/07/06 17:48:34 flameeyes Exp $

inherit games

DESCRIPTION="Sierra script interpreter for your old Sierra adventures"
HOMEPAGE="http://freesci.linuxgames.com/"
SRC_URI="http://www-plan.cs.colorado.edu/reichenb/freesci/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86" # upstream asked us to not stabilize this version
IUSE="X ggi directfb alsa sdl ncurses"

RDEPEND="
	X? (
		x11-libs/libXi
		x11-libs/libXrender
		=media-libs/freetype-2* )
	ggi? ( media-libs/libggi )
	directfb? ( dev-libs/DirectFB )
	alsa? ( >=media-libs/alsa-lib-0.5.0 )
	sdl? ( >=media-libs/libsdl-1.1.8 )
	ncurses? ( sys-libs/ncurses )"
DEPEND="${RDEPEND}
	X? (
		x11-libs/libXft
		x11-libs/libXt )"

pkg_setup() {
	games_pkg_setup

	if use alsa && ! built_with_use --missing true media-libs/alsa-lib midi; then
		eerror ""
		eerror "To be able to build ${CATEGORY}/${PN} with ALSA support you"
		eerror "need to have built media-libs/alsa-lib with midi USE flag."
		die "Missing midi USE flag on media-libs/alsa-lib"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/^SUBDIRS/ s/conf debian//" Makefile.in \
			|| die "sed Makefile.in failed"
}
src_compile() {
	egamesconf \
		$(use_with X x) \
		$(use_with sdl) \
		$(use_with directfb) \
		$(use_with ggi) \
		$(use_with alsa) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README README.Unix THANKS TODO
	prepgamesdirs
}
