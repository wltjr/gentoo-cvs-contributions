# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/iperf/iperf-2.0.4.ebuild,v 1.1 2008/07/30 01:49:46 jer Exp $

DESCRIPTION="tool to measure IP bandwidth using UDP or TCP"
HOMEPAGE="http://iperf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="ipv6 threads debug"

DEPEND="virtual/libc"

src_compile() {
	econf \
		$(use_enable ipv6) \
		$(use_enable threads) \
		$(use_enable debug debuginfo) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc INSTALL README
	dohtml doc/*
	newinitd ${FILESDIR}/${PN}.initd ${PN}
	newconfd ${FILESDIR}/${PN}.confd ${PN}
}

pkg_postinst() {
	echo
	einfo "To run iperf in server mode, run:"
	einfo "  /etc/init.d/iperf start"
	echo
}
