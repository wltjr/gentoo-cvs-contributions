# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/isomaster/isomaster-1.3.1.ebuild,v 1.1 2008/02/14 17:01:41 drac Exp $

inherit toolchain-funcs

DESCRIPTION="Graphical CD image editor for reading, modifying and writing ISO images"
HOMEPAGE="http://littlesvr.ca/isomaster"
SRC_URI="http://littlesvr.ca/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	tc-export CC
	emake PREFIX="/usr" || die "emake failed."
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install || die "emake install failed."
	dodoc {CHANGELOG,CREDITS,README,TODO}.TXT
}
