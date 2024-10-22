# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/ipchains-firewall/ipchains-firewall-1.7.3.ebuild,v 1.6 2006/05/29 04:58:21 antarus Exp $

S=${WORKDIR}/ipchains-firewall-1.7
DESCRIPTION="IP-Chains Firewall Script "
SRC_URI="mirror://sourceforge/plonk/${P}.tar.gz"
HOMEPAGE="http://plonk.sourceforge.net/"
KEYWORDS="x86 sparc "
IUSE=""
LICENSE="as-is"
SLOT="0"

RDEPEND="dev-lang/perl"

src_install() {
	cd ${S}
	into /usr
	dosbin firewall.sh
	dodoc README
	cd midentd-1.6
	insinto /etc
	doins midentd.conf midentd.mircusers
	dodir /var/log
	touch ${D}/var/log/midentd.log
	chown nobody ${D}/var/log/midentd.log
	dosbin midentd midentd.logcycle
	docinto midentd
	dodoc CHANGES README LICENSE
}
