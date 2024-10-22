# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/coe2/coe2-2007.ebuild,v 1.1 2007/08/29 21:38:39 tupone Exp $

inherit eutils games

DESCRIPTION="Precursor to the Dominions series"
HOMEPAGE="http://www.shrapnelgames.com/Illwinter/CoE2/"
SRC_URI="http://download.shrapnelgames.com/downloads/${PN}_${PV}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-libs/libsdl"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/coe

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm *.{dll,exe}
	rm -r old
	use amd64 && mv -f coe_linux64bit coe_linux || die "mv amd64 image failed"
}

src_install() {
	insinto "${GAMES_PREFIX_OPT}/${PN}"
	doins *.{bgm,smp,trp,trs,wrl} || die " doins failed"
	dodoc history.txt manual.txt readme.txt
	exeinto "${GAMES_PREFIX_OPT}/${PN}"
	doexe coe_linux || die "doexe failed"

	games_make_wrapper ${PN} "./coe_linux" "${GAMES_PREFIX_OPT}/${PN}"
	make_desktop_entry ${PN} "Conquest of Elysium 2"

	# Slots for saved games.
	# The game shows e.g. "EMPTY SLOT 0?", but it works.
	local f slot state_dir=${GAMES_STATEDIR}/${PN}
	dodir "${state_dir}"
	for slot in {0..4} ; do
		f=save${slot}
		dosym "${state_dir}/save${slot}" "${dir}/${f}" || die "dosym"
		echo "empty slot ${slot}" > "${D}${state_dir}/${f}" || die "echo"
		fperms 660 "${state_dir}/${f}" || die "fperms"
	done

	prepgamesdirs
}
