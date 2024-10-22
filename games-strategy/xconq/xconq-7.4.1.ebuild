# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/xconq/xconq-7.4.1.ebuild,v 1.11 2007/06/11 16:42:06 nyhm Exp $

inherit eutils games

DESCRIPTION="a general strategy game system"
HOMEPAGE="http://sources.redhat.com/xconq/"
SRC_URI="ftp://sources.redhat.com/pub/xconq/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""
RESTRICT="test"

DEPEND="x11-libs/libXmu
	x11-libs/libXaw
	dev-lang/tk
	dev-lang/tcl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch \
		"${FILESDIR}"/${PN}-gcc-3.4.patch \
		"${FILESDIR}"/${PN}-tkconq.patch
}

src_compile() {
	egamesconf \
		--enable-alternate-scoresdir="${GAMES_STATEDIR}"/${PN} \
		|| die
	emake \
		CFLAGS="${CFLAGS}" \
		datadir="${GAMES_DATADIR}"/${PN} \
		|| die "emake failed"
}

src_install() {
	dogamesbin x11/{imf2x,x2imf,xconq,ximfapp} || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images lib tcltk/*.tcl || die "doins failed"
	rm -f "${D}/${GAMES_DATADIR}"/${PN}/{images,lib}/{m,M}ake*

	dodir "${GAMES_STATEDIR}"/${PN}
	touch "${D}/${GAMES_STATEDIR}"/${PN}/scores.xcq
	fperms 660 "${GAMES_STATEDIR}"/${PN}/scores.xcq || die

	doman x11/${PN}.6
	dodoc ChangeLog NEWS README
	prepgamesdirs
}
