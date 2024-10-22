# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mktemp/mktemp-1.5.ebuild,v 1.12 2008/01/23 04:42:34 vapier Exp $

inherit eutils

DESCRIPTION="allow safe temporary file creation from shell scripts."
HOMEPAGE="http://www.mktemp.org/"
SRC_URI="ftp://ftp.mktemp.org/pub/mktemp/mktemp-1.5.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=">=sys-apps/debianutils-2.16.2"
RDEPEND="${DEPEND}
	!>=sys-apps/coreutils-6.10"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	econf --with-libc || die
	emake || die
}

src_install() {
	into /
	dobin mktemp || die
	newman mktemp.man mktemp.1
	dodoc README RELEASE_NOTES
}
