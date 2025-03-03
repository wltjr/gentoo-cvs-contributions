# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/schedutils/schedutils-1.5.0.ebuild,v 1.5 2007/11/15 19:11:27 vapier Exp $

inherit eutils

DESCRIPTION="Utilities for manipulating kernel schedular parameters"
HOMEPAGE="http://rlove.org/schedutils/"
SRC_URI="http://rlove.org/schedutils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND="!>=sys-apps/util-linux-2.13_pre"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-powerpc.patch
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS} ${LDFLAGS}" \
		PREFIX=/usr \
		|| die "Make failed"
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	emake install PREFIX="${D}"/usr || die "Install failed"
	dodoc AUTHORS ChangeLog README
}
