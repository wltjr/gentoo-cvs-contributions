# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iptstate/iptstate-2.2.1.ebuild,v 1.9 2008/06/28 20:31:41 loki_val Exp $

inherit base

DESCRIPTION="IP Tables State displays states being kept by iptables in a top-like format"
SRC_URI="http://www.phildev.net/iptstate/${P}.tar.bz2"
HOMEPAGE="http://www.phildev.net/iptstate/"

DEPEND="sys-libs/ncurses
	>=net-libs/libnetfilter_conntrack-0.0.50"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~hppa ~ppc sparc x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-gcc43.patch" )

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make PREFIX="${D}"/usr install || die
	dodoc README Changelog BUGS CONTRIB WISHLIST
}
