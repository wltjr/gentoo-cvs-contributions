# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdcd/cdcd-0.6.6.ebuild,v 1.10 2006/06/16 21:13:53 flameeyes Exp $

IUSE=""

inherit eutils

DESCRIPTION="a simple yet powerful command line cd player"
SRC_URI="mirror://sourceforge/libcdaudio/${P}.tar.gz"
HOMEPAGE="http://cdcd.undergrid.net/"
DEPEND=">=sys-libs/ncurses-5.0
	>=sys-libs/readline-4.2
	>=media-libs/libcdaudio-0.99.4"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc sparc ppc64"

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README
}
