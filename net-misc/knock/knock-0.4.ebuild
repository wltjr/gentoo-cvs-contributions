# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knock/knock-0.4.ebuild,v 1.1 2005/03/14 17:49:52 pyrania Exp $

inherit eutils

MY_PV="${PV/%.0}"
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="A simple port-knocking daemon"
HOMEPAGE="http://www.zeroflux.org/knock/"
SRC_URI="http://www.zeroflux.org/knock/files/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libpcap
	>=sys-apps/portage-2.0.51"
RDEPEND="net-firewall/iptables
	${DEPEND}"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README
	dodoc ChangeLog
	dodoc TODO

	dosed "s:/usr/sbin/iptables:/sbin/iptables:g" /etc/knockd.conf

	newinitd ${FILESDIR}/knockd.initd knock
	newconfd ${FILESDIR}/knockd.confd knock
}
