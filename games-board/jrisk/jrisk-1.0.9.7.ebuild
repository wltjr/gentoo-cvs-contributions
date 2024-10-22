# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/jrisk/jrisk-1.0.9.7.ebuild,v 1.1 2008/06/03 06:27:07 mr_bones_ Exp $

inherit eutils java-pkg-2 java-ant-2 games

DESCRIPTION="The well-known board game, written in java"
HOMEPAGE="http://jrisk.sourceforge.net"
SRC_URI="mirror://sourceforge/jrisk/backup_of_Risk_${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S=${WORKDIR}/Risk

pkg_setup() {
	games_pkg_setup
	java-pkg-2_pkg_setup
}

EANT_BUILD_TARGET="game"

src_compile() {
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dolauncher ${PN} \
		-into "${GAMES_PREFIX}" \
		--main risk.ui.FlashGUI.MainMenu \
		--pwd  "${GAMES_DATADIR}/${PN}"

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r build/game/* || die "doins failed"
	rm -f "${D}${GAMES_DATADIR}"/${PN}/*.cmd || die
	java-pkg_regjar "${D}/${GAMES_DATADIR}/${PN}"/*.jar

	newicon resources/icon.png ${PN}.png
	make_desktop_entry ${PN} "Risk"

	prepgamesdirs
}
