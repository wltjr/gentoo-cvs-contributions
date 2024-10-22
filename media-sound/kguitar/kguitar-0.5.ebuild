# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kguitar/kguitar-0.5.ebuild,v 1.6 2008/06/09 11:28:33 flameeyes Exp $

inherit kde

DESCRIPTION="An efficient and easy-to-use environment for a guitarist"
HOMEPAGE="http://kguitar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE=""

# hard-dep on tse3, without it causes Settings->Configure KGuitar to crash. (eldad 15 April 2006)
DEPEND=">=media-libs/tse3-0.2.3"
need-kde 3

PATCHES=(
	"${FILESDIR}"/${P}+gcc-4.3.patch
)

src_compile() {
	myconf="--with-tse3"
	kde_src_compile
}
