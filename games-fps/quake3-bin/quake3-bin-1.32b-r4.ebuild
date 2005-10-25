# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-bin/quake3-bin-1.32b-r4.ebuild,v 1.1 2005/10/25 00:38:03 vapier Exp $

inherit eutils games

DESCRIPTION="Quake III Arena - 3rd installment of the classic id 3D first-person shooter"
HOMEPAGE="http://www.idsoftware.com/"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/quake3/linux/linuxq3apoint-${PV}-3.x86.run"

LICENSE="Q3AEULA"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="cdinstall dedicated opengl"
RESTRICT="nostrip"

RDEPEND="sys-libs/glibc
	opengl? ( virtual/opengl
		virtual/x11 )
	dedicated? ( app-misc/screen )
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		opengl? (
			app-emulation/emul-linux-x86-xlibs
			|| ( >=media-video/nvidia-glx-1.0.6629-r3
			>=media-video/ati-drivers-8.8.25-r1 ) ) )
	cdinstall? ( games-fps/quake3-data )"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/quake3
Ddir=${D}/${dir}

pkg_setup() {
	check_license Q3AEULA
	games_pkg_setup
}

src_unpack() {
	unpack_makeself
}

src_install() {
	if use cdinstall ; then
		dodir ${dir}/{baseq3,missionpack}
		for pk3 in baseq3/*.pk3 missionpack/*.pk3 ; do
			dosym ${GAMES_DATADIR}/quake3/${pk3} ${dir}/${pk3}
		done
	else
		insinto ${dir}/baseq3
		doins baseq3/*.pk3 || die "ins baseq3"
		insinto ${dir}/missionpack
		doins missionpack/*.pk3 || die "ins missionpack"
	fi

	insinto ${dir}
	doins -r Docs pb || die "ins docs/pb"

	exeinto ${dir}
	insinto ${dir}
	doexe bin/Linux/x86/{quake3.x86,q3ded} || die "doexe"
	doins quake3.xpm README* Q3A_EULA.txt
	games_make_wrapper quake3-bin ./quake3.x86 "${dir}" "${dir}"
	games_make_wrapper q3ded-bin ./q3ded "${dir}" "${dir}"

	newinitd "${FILESDIR}"/q3ded.rc q3ded
	newconfd "${FILESDIR}"/q3ded.conf.d q3ded
	newicon quake3.xpm quake3-bin.xpm

	prepgamesdirs
	make_desktop_entry quake3-bin "Quake III Arena (binary)" quake3-bin.xpm
}

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "There are two possible security bugs in this package, both causing a	denial"
	ewarn "of service.  One affects the game when running a server, the other when running"
	ewarn "as a client.  For more information, see bug #82149."
	if ! use cdinstall ; then
		echo
		einfo "You need to copy pak0.pk3 from your Quake3 CD into ${dir}/baseq3."
		einfo "Or if you have got a Window installation of Q3 make a symlink to save space."
	fi
	if use dedicated; then
		echo
		einfo "To start a dedicated server, run"
		einfo "  /etc/init.d/q3ded start"
		echo
		einfo "The dedicated server is started under the ${GAMES_USER_DED} user account."
	fi

	# IA32 Emulation required for amd64
	if use amd64 ; then
		echo
		ewarn "NOTE: IA32 Emulation must be compiled into your kernel for Quake3 to run."
	fi
}
