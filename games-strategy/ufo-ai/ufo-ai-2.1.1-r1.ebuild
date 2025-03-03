# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/ufo-ai/ufo-ai-2.1.1-r1.ebuild,v 1.3 2008/02/29 19:49:07 carlo Exp $

inherit eutils autotools games

MY_P=${P/-}
DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
HOMEPAGE="http://ufoai.ninex.info/"
SRC_URI="mirror://sourceforge/ufoai/music.tar.bz2
	mirror://sourceforge/ufoai/${MY_P}-data.tar
	mirror://sourceforge/ufoai/${MY_P}-source_hotfix.tar.bz2
	mirror://sourceforge/ufoai/${MY_P}-i18n.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa arts debug dedicated dga doc ipv6 jack master oss paranoid"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/jpeg
	media-libs/libpng
	media-libs/libogg
	media-libs/libvorbis
	x11-libs/libXxf86vm
	virtual/libintl
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	dga? ( x11-libs/libXxf86dga )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	x11-proto/xf86vidmodeproto
	x11-proto/xproto
	doc? ( app-doc/doxygen )
	dga? ( x11-proto/xf86dgaproto )"

S=${WORKDIR}/${MY_P}-source
dir=${GAMES_DATADIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	local libdir=$(games_get_libdir)/${PN}
	# Set libdir
	sed -i \
		-e "s:libPath, \"\.\":libPath, \"${libdir}\":" \
		src/{client,ports/linux}/*.c || die "sed *.c failed"

	sed -i \
		-e "s:\"s_libdir\", \"\":\"s_libdir\", \"${libdir}\":" \
		src/client/snd_ref.c || die "sed snd_ref.c failed"

	sed -i \
		-e "s:game\.so\", path:game\.so\", \"${libdir}\":" \
		src/ports/linux/sys_linux.c || die "sed sys_linux.c failed"

	# Set basedir
	sed -i \
		-e "s:\"fs_basedir\", \"\.\":\"fs_basedir\", \"${dir}\":" \
		src/qcommon/files.c || die "sed files.c failed"

	sed -i \
		-e "s:/usr/local/games/ufoai:${dir}:" \
		src/tools/gtkradiant/games/ufoai.game || die "sed ufoai.game failed"

	# Fixes bug in finding text files - it should use fs_basedir
	sed -i \
		-e "s:FS_GetCwd():\"${dir}\":" \
		src/qcommon/common.c || die "sed common.c failed"

	eautoreconf
}

src_compile() {
# Forces building of client.
# gettext is required to show the intro text.
# egamesconf fails with openal.
#		$(use_with openal)
	egamesconf \
		$(use_enable dedicated) \
		$(use_enable master) \
		$(use_enable !debug release) \
		$(use_enable paranoid) \
		--with-vid-glx \
		--with-vid-vidmode \
		--with-sdl \
		--with-snd-sdl \
		$(use_with alsa snd-alsa) \
		$(use_with arts snd-arts) \
		$(use_with jack snd-jack) \
		$(use_with oss snd-oss) \
		$(use_with dga vid-dga) \
		$(use_with ipv6) \
		--with-gettext \
		--without-openal \
		|| die "egamesconf failed"

	emake || die "emake failed"

	if use doc ; then
		emake docs || die "emake docs failed"
	fi
}

src_install() {
	# ufo is usually started by a "ufoai" wrapper script.
	# Might as well standardize on the ebuild name, for minimum confusion.
	newgamesbin ufo ${PN} || die
	newicon src/ports/linux/installer/data/ufo.xpm ${PN}.xpm || die
	make_desktop_entry ${PN} "UFO: Alien Invasion" ${PN}

	if use dedicated ; then
		dogamesbin ufoded || die
	fi

	if use master ; then
		dogamesbin ufomaster || die
	fi

	if [[ -f ufo2map ]] ; then
		dogamesbin ufo2map || die
	fi

	exeinto "$(games_get_libdir)/${PN}"
	doexe *.so base/game.so || die "doexe ${f} failed"

	insinto "${dir}"
	doins -r "${WORKDIR}"/{base,music} || die "doins -r failed"

	if use doc ; then
		dohtml -r "${WORKDIR}"/docs/html/*
	fi

	prepgamesdirs
}
