# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpri/libpri-1.0.2.ebuild,v 1.2 2004/11/10 14:53:36 gustavoz Exp $

IUSE=""

DESCRIPTION="Primary Rate ISDN (PRI) library"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="ftp://ftp.asterisk.org/pub/telephony/libpri/libpri-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND="virtual/libc"

src_compile() {
	emake || die
}

src_install() {
	make INSTALL_PREFIX=${D} install || die

	dodoc ChangeLog README TODO
}
