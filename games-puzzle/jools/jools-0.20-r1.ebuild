# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/jools/jools-0.20-r1.ebuild,v 1.2 2008/05/29 16:54:46 hawking Exp $

inherit eutils python games

MUS_P=${PN}-musicpack-1.0
DESCRIPTION="clone of Bejeweled, a popular pattern-matching game"
HOMEPAGE="http://www.eecs.umich.edu/~pelzlpj/jools/"
SRC_URI="http://www.eecs.umich.edu/~pelzlpj/jools/${P}.tar.gz
	 http://www.eecs.umich.edu/~pelzlpj/jools/${MUS_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygame"
DEPEND=""

S=${WORKDIR}/${P}/jools

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	echo "MEDIAROOT = \"${GAMES_DATADIR}/${PN}\"" > config.py
	cd music
	unpack ${MUS_P}.tar.gz
}

src_install() {
	games_make_wrapper ${PN} "python ./__init__.py" "$(games_get_libdir)"/${PN}
	insinto "$(games_get_libdir)"/${PN}
	doins *.py || die "doins py failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r fonts images music sounds || die "doins data failed"
	newicon images/ruby/0001.png ${PN}.png
	make_desktop_entry ${PN} Jools
	dodoc ../{ChangeLog,doc/{POINTS,TODO}}
	dohtml ../doc/manual.html
	prepgamesdirs
}

pkg_postinst() {
	python_mod_optimize "$(games_get_libdir)"/${PN}
	games_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "$(games_get_libdir)"/${PN}
}
