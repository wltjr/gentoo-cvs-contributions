# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/supertransball2/supertransball2-1.5.ebuild,v 1.2 2007/04/24 15:14:45 drizzt Exp $

inherit eutils versionator games

MY_PV=$(delete_all_version_separators)
MY_P=stransball2-v${MY_PV}
FILE=${MY_P}-linux
DEBIAN_PATCH="${PN}_${PV}-3.diff"

DESCRIPTION="Thrust clone"
HOMEPAGE="http://www.braingames.getput.com/stransball2/"
SRC_URI="http://braingames.bugreport.nl/stransball2/${FILE}.zip
	mirror://debian/pool/main/s/${PN}/${DEBIAN_PATCH}.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-sound
	media-libs/sge"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P}/sources

src_unpack() {
	unpack ${A}
	mv -f "${FILE}" ${P}

	sed -i \
		-e "s:/usr/share/games:${GAMES_DATADIR}:" \
		"${DEBIAN_PATCH}" || die "sed patch failed"

	epatch "${DEBIAN_PATCH}"

	local deb_dir=${P}/debian/patches
	rm -f "${deb_dir}"/00list
	local p
	for p in "${deb_dir}"/* ; do
		epatch "${p}"
	done

	sed -i \
		-e "s: -I/usr/local/include/SDL::" \
		-e "s:-g3 -O3:\$(CXXFLAGS):" \
		"${S}"/Makefile || die "sed Makefile failed"
}

src_install() {
	cd ..
	dogamesbin ${PN} || die "dogamesbin failed"
	make_desktop_entry ${PN} "Super Transball 2"
	dodoc readme.txt || die "Installing doc failed"
	doman debian/supertransball2.6 || die "Installing man page failed"

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r demos graphics maps sound || die "doins -r failed"

	prepgamesdirs
}
