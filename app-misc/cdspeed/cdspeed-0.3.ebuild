# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdspeed/cdspeed-0.3.ebuild,v 1.11 2004/12/13 03:20:58 weeve Exp $

DESCRIPTION="Change the speed of your CD drive"
HOMEPAGE="http://linuxfocus.org/~guido/"
SRC_URI="http://linuxfocus.org/~guido/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~mips alpha ~hppa ~amd64"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e 's:^CFLAGS=.*:CFLAGS=$(E_CFLAGS):' \
		Makefile || die "sed Makefile failed"
}

src_compile() {
	emake E_CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin cdspeed || die "dobin failed"
	exeinto /usr/lib/cdspeed
	doexe cdmount || die "doexe failed"
	dodoc README
}
