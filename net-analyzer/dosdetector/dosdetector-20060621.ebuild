# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/dosdetector/dosdetector-20060621.ebuild,v 1.2 2006/10/15 12:30:19 tcort Exp $

DESCRIPTION="Tool to analyze and detect suspicious traffic from IP and alert
about it"
HOMEPAGE="http://darkzone.ma.cx/resources/unix/dosdetector/"
SRC_URI="http://darkzone.ma.cx/resources/unix/dosdetector/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND=""

S=${WORKDIR}/${P}

src_install() {
	einstall || die "einstall failed"
}
