# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lxsplit/lxsplit-0.1.1.ebuild,v 1.12 2005/01/01 15:13:08 eradicator Exp $

DESCRIPTION="Command-line file splitter/joiner for Linux"
HOMEPAGE="http://remenic.2y.net/lxsplit/"
SRC_URI="http://www.freebyte.com/download/lxsplit.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE=""

src_compile() {
	sed -i "s/^\(CFLAGS[[:space:]]=[[:space:]]\)\(.*\)$/\1${CFLAGS}/" Makefile
	emake || die
}

src_install() {
	dobin lxsplit || die
	dodoc ChangeLog README
}
