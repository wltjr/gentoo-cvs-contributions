# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/fakeidentd/fakeidentd-2.4.ebuild,v 1.9 2007/02/22 20:45:53 gmsoft Exp $

inherit toolchain-funcs eutils

DESCRIPTION="A static, secure identd.  One source file only!"
HOMEPAGE="http://www.guru-group.fi/~too/sw/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	sed -i "s:identd.pid:${PN}.pid:" identd.c
	epatch "${FILESDIR}"/${PN}-2.2-ident-unix.patch
}

src_compile() {
	$(tc-getCC) ${LDFLAGS} identd.c -o ${PN} ${CFLAGS} || die
}

src_install() {
	dosbin ${PN} || die
	# Changelog in source is more current. Its only ~13kB anyway.
	dodoc identd.readme identd.c

	newinitd "${FILESDIR}"/fakeidentd.rc fakeidentd
	newconfd "${FILESDIR}"/fakeidentd.confd fakeidentd
}
