# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/rtcwmp-demo/rtcwmp-demo-1.1.ebuild,v 1.9 2007/04/28 18:08:33 swegener Exp $

inherit eutils games

MY_P="wolfmpdemo-linux-${PV}-MP.x86.run"

DESCRIPTION="Return to Castle Wolfenstein - Multi-player demo"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
SRC_URI="mirror://idsoftware/wolf/linux/old/${MY_P}
	mirror://3dgamers/returnwolfenstein/${MY_P}"

LICENSE="RTCW"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="dedicated opengl"
RESTRICT="strip mirror"

RDEPEND="sys-libs/glibc
	dedicated? (
		app-misc/screen )
	!dedicated? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXau
		x11-libs/libXdmcp )
	opengl? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXau
		x11-libs/libXdmcp )
	amd64? (
		app-emulation/emul-linux-x86-xlibs )"

S=${WORKDIR}

GAMES_CHECK_LICENSE="yes"
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself ${A} || die "Unpacking files"
}

src_install() {
	insinto "${dir}"
	doins -r demomain Docs

	exeinto "${dir}"
	doexe bin/x86/*.x86 openurl.sh || die "copying exe"

	games_make_wrapper rtcwmp-demo ./wolf.x86 "${dir}" "${dir}"

	if use dedicated; then
		games_make_wrapper rtcwmp-demo-ded ./wolfded.x86 "${dir}" "${dir}"
		newinitd "${FILESDIR}"/rtcwmp-demo-ded.rc rtcwmp-demo-ded
		dosed "s:GENTOO_DIR:${dir}:" /etc/init.d/rtcwmp-demo-ded
	fi

	doins WolfMP.xpm CHANGES QUICKSTART
	newicon WolfMP.xpm rtcwmp-demo.xpm

	prepgamesdirs
	make_desktop_entry rtcwmp-demo "Return to Castle Wolfenstein (MP demo)" \
		rtcwmp-demo.xpm
}

pkg_postinst() {
	games_pkg_postinst
	elog "Install 'rtcwsp-demo' for single-player"
	elog
	elog "Run 'rtcwmp-demo' for multi-player"
	if use dedicated; then
		elog
		elog "Start a dedicated server with"
		elog "'/etc/init.d/rtcwmp-demo-ded start'"
		elog
		elog "Start the server at boot with"
		elog "'rc-update add rtcwmp-demo-ded default'"
	fi
}
