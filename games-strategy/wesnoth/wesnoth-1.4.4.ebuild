# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wesnoth/wesnoth-1.4.4.ebuild,v 1.1 2008/07/23 17:35:42 mr_bones_ Exp $

inherit eutils toolchain-funcs flag-o-matic games

MY_PV=${PV/_/}
DESCRIPTION="Battle for Wesnoth - A fantasy turn-based strategy game"
HOMEPAGE="http://www.wesnoth.org/"
SRC_URI="mirror://sourceforge/wesnoth/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dedicated editor lite nls server static tools"

RDEPEND=">=media-libs/libsdl-1.2.7
	media-libs/sdl-net
	dev-libs/boost
	!dedicated? (
		x11-libs/libX11
		>=media-libs/sdl-mixer-1.2
		>=media-libs/sdl-image-1.2
		dev-lang/python
		>=media-libs/freetype-2 )
	nls? ( virtual/libintl )"
# the configure script is broken and checks for freetype even if
# it won't be used.  until it's either patched out or upstream fixes
# it, just make it a DEPEND.
# reported by Miika Linnapuomi
DEPEND="${RDEPEND}
	dedicated? (
		>=media-libs/sdl-mixer-1.2
		>=media-libs/sdl-image-1.2
		>=media-libs/freetype-2 )
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${MY_PV}

pkg_setup() {
	if ! built_with_use media-libs/sdl-mixer vorbis ; then
		die "Please emerge media-libs/sdl-mixer with USE=vorbis"
	fi
	if ! built_with_use media-libs/sdl-image png ; then
		die "Please emerge media-libs/sdl-image with USE=png"
	fi
	# dedicated also needs USE=X for libsdl: bug #222033
	if ! built_with_use media-libs/libsdl X ; then
		die "Please emerge media-libs/libsdl with USE=X"
	fi
	games_pkg_setup
}

src_unpack() {
	unpack ${A}
	if use dedicated || use server ; then
		sed \
			-e "s:GAMES_BINDIR:${GAMES_BINDIR}:" \
			-e "s:GAMES_STATEDIR:${GAMES_STATEDIR}:" \
			-e "s/GAMES_USER_DED/${GAMES_USER_DED}/" \
			-e "s/GAMES_GROUP/${GAMES_GROUP}/" "${FILESDIR}"/wesnothd.rc \
			> "${T}"/wesnothd \
			|| die "sed failed"
	fi
	if ! use nls ; then
		cd "${S}"
		sed -i \
			-e '/^MAN_LANG/d' \
			doc/man/Makefile.in \
			|| die "sed failed"
	fi
}

src_compile() {
	local myconf

	filter-flags -ftracer -fomit-frame-pointer
	if [[ $(gcc-major-version) -eq 3 ]] ; then
		filter-flags -fstack-protector
		append-flags -fno-stack-protector
	fi
	if use dedicated || use server ; then
		myconf="${myconf} --enable-server"
		myconf="${myconf} --enable-campaign-server"
		myconf="${myconf} --with-server-uid=${GAMES_USER_DED}"
		myconf="${myconf} --with-server-gid=${GAMES_GROUP}"
	fi
	egamesconf \
		--disable-dependency-tracking \
		--without-fribidi \
		--with-localedir=/usr/share/locale \
		--with-icondir=/usr/share/icons \
		--with-desktopdir=/usr/share/applications \
		--docdir=/usr/share/doc/${PF} \
		--enable-python-install \
		$(use_enable lite) \
		$(use_enable static) \
		$(use_enable editor) \
		$(use_enable tools) \
		$(use_enable nls) \
		$(use_enable nls dummy-locales) \
		$(use_enable !dedicated game) \
		${myconf} \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc changelog
	if use dedicated || use server; then
		keepdir "${GAMES_STATEDIR}/run/wesnothd"
		doinitd "${T}"/wesnothd || die "doinitd failed"
	fi
	prepgamesdirs
}
