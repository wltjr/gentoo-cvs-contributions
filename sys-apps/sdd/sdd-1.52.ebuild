# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sdd/sdd-1.52.ebuild,v 1.5 2008/06/20 21:39:28 swegener Exp $

DESCRIPTION="A fast and enhanced 'dd' replacement for UNIX"
HOMEPAGE="http://ftp.berlios.de/pub/sdd/"
SRC_URI="http://ftp.berlios.de/pub/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""
DEPEND=""

src_compile() {
	# Can't use default src_compile, because ./configure will bail out
	emake || die "emake failed"
}

src_install() {
	dobin ${PN}/OBJ/*/${PN} || die "dobin failed"
	doman ${PN}/${PN}.1 || die "doman failed"
	dodoc README || die "dodoc failed"
}
