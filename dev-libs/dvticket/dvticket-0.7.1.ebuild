# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvticket/dvticket-0.7.1.ebuild,v 1.4 2004/06/24 23:07:28 agriffis Exp $

S=${WORKDIR}/dvticket-${PV}
DESCRIPTION="dvticket provides a framework for a ticket server"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvticket/download/dvticket-${PV}.tar.gz"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvticket/html/"
KEYWORDS="~x86 ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE=""
DEPEND="virtual/glibc
	dev-libs/dvutil
	dev-libs/dvnet
	dev-libs/dvcgi"

src_install() {
	make prefix=${D}/usr install
}
