# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/beep/beep-1.2.2-r1.ebuild,v 1.10 2008/05/11 13:43:41 mr_bones_ Exp $

inherit eutils base toolchain-funcs

DESCRIPTION="The advanced PC speaker beeper"
HOMEPAGE="http://www.johnath.com/beep/"
SRC_URI="mirror://gentoo/${P}.tar.gz http://www.johnath.com/beep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm alpha amd64 ppc ppc64 sparc x86"
IUSE=""

PATCHES="${FILESDIR}/${P}-nosuid.patch"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's/CC=gcc/CC?=gcc/' Makefile || ewarn "Have I been fixed?"
}
src_compile() {
	emake CC=$(tc-getCC) FLAGS="${CFLAGS}" || die "compile problem"
}

src_install() {
	dobin beep
	fperms 0711 /usr/bin/beep
	doman beep.1.gz
	dodoc CHANGELOG CREDITS README
}
