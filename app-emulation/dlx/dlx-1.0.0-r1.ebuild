# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/dlx/dlx-1.0.0-r1.ebuild,v 1.2 2005/01/01 14:09:37 eradicator Exp $

S=${WORKDIR}/dlx
DESCRIPTION="DLX Simulator"
HOMEPAGE="http://www.davidviner.com/dlx.php"
SRC_URI="http://www.davidviner.com/dlx/dlx.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=""

src_compile() {
	emake || die
}

src_install() {
	dodir /usr/include/dlx /usr/share/dlx/examples
	dobin masm mon dasm
	insinto /usr/include/dlx
	doins *.i auto.a
	insinto /usr/share/dlx/examples
	doins *.a hp.m
	dodoc README.txt MANUAL.TXT
}
