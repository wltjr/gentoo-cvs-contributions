# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rcenter/rcenter-0.6.2.ebuild,v 1.14 2007/07/11 19:30:24 mr_bones_ Exp $

inherit eutils toolchain-funcs

IUSE=""

DESCRIPTION="Rcenter - A program to control the EMU10K Remote Control"
HOMEPAGE="http://rooster.stanford.edu/~ben/projects/rcenter.php"
SRC_URI="http://rooster.stanford.edu/~ben/projects/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
#-sparc: emu10k1 doesn't get recognized on sparc hardware
KEYWORDS="amd64 -sparc x86"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	chmod 755 rcenter
	dobin rcenter
	dodir /usr/share/rcenter
	cp -R config ${D}/usr/share/rcenter/
	dodoc HISTORY LICENSE README
}

pkg_postinst() {
	elog "Rcenter Installed  - However You need to setup the scripts"
	elog "for making remote control commands actually work"
	elog
	elog "The Skel scripts can be copied from /usr/share/rcenter/config to <user>/.rcenter"
	elog "Where <user> is a person who will use rcenter"
	elog "Remeber to use emu-config -i to turn on the remote"
}
