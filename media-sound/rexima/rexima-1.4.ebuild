# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rexima/rexima-1.4.ebuild,v 1.13 2004/12/19 06:23:54 eradicator Exp $

IUSE=""

DESCRIPTION="A curses-based interactive mixer which can also be used from the command-line."
HOMEPAGE="http://rus.members.beeb.net/rexima.html"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/apps/sound/mixers/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="sys-libs/ncurses"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install () {
	make \
		PREFIX="${D}/usr" \
		BINDIR="${D}/usr/bin" \
		MANDIR="${D}/usr/share/man" \
		install || die "make install failed"
	dodoc NEWS README
}
