# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/ipp2p/ipp2p-0.7.ebuild,v 1.2 2005/01/11 10:39:33 eradicator Exp $

IUSE=""

inherit linux-mod eutils

DESCRIPTION="Netfilter module for dealing with P2P Applications."
HOMEPAGE="http://www.ipp2p.org/index_en.html"
SRC_URI="http://www.ipp2p.org/downloads/${P}.tar.gz"

SLOT="${KV}"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/modutils"

DEPEND="${RDEPEND}
	>=net-firewall/iptables-1.2.11
	virtual/linux-sources"

pkg_setup() {
	CONFIG_CHECK="NETFILTER"
	NETFILTER_ERROR="Your kernel is not configured to support Netfilter."
	MODULE_NAMES="ipt_ipp2p"

	linux-mod_pkg_setup
}

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-Makefile.patch
}

src_compile() {
	xarch="${ARCH}"
	unset ARCH
	emake KERNEL_SRC=${KV_DIR} || die "Parallel Make Failed"
	ARCH="${xarch}"
}

src_install() {
	exeinto /$(get_libdir)/iptables
	doexe libipt_ipp2p.so

	dodoc README
	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst
}
