# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tpconfig/tpconfig-3.1.3.ebuild,v 1.2 2002/11/30 21:51:07 vapier Exp $

DESCRIPTION="Touchpad config for ALPS and Synaptics TPs. Controls tap/click behaviour"
HOMEPAGE="http://www.compass.com/synaptics/"
SRC_URI="http://www.compass.com/${PN}/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"

src_compile() {
	econf
	emake || die "Failed emake"
}

src_install() {
	dobin tpconfig
	dodoc README AUTHORS NEWS INSTALL COPYING
	exeinto /etc/init.d ; doexe ${FILESDIR}/tpconfig
	insinto /etc/conf.d ; newins ${FILESDIR}/tpconfig.conf tpconfig
}
