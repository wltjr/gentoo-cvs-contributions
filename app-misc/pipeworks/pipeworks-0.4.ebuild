# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pipeworks/pipeworks-0.4.ebuild,v 1.8 2005/01/01 15:19:32 eradicator Exp $

DESCRIPTION="a small utility that measures throughput between stdin and stdout"
HOMEPAGE="http://pipeworks.sourceforge.net/"
SRC_URI="mirror://sourceforge/pipeworks/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin pipeworks || die "dobin failed"
	doman pipeworks.1
	dodoc Changelog README
}
