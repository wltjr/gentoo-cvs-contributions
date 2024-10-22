# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/byld/byld-1.0.3.ebuild,v 1.3 2004/06/30 14:34:46 agriffis Exp $

DESCRIPTION="build a Linux distribution on a single floppy"
HOMEPAGE="http://byld.sourceforge.net/"
SRC_URI="mirror://sourceforge/byld/byld-${PV//./_}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="sys-apps/util-linux"

src_install() {
	dodoc BYLDING CREDITS README INSTALL FHS PAKING
	rm MAKEDEV.8 BYLDING CREDITS README INSTALL FHS LICENSE PAKING
	dodir /usr/lib/${PN}
	cp -rf * ${D}/usr/lib/${PN}/
}

pkg_postinst() {
	einfo "The build scripts have been placed in /usr/lib/${PN}"
	einfo "For documentation, see /usr/share/doc/${PF}"
}
