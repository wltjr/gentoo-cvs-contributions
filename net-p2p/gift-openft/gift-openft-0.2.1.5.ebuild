# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gift-openft/gift-openft-0.2.1.5.ebuild,v 1.3 2005/02/02 16:56:54 squinky86 Exp $

IUSE="berkdb"
DESCRIPTION="The giFT OpenFT plugin"
HOMEPAGE="http://gift.sf.net/"
SRC_URI="mirror://sourceforge/gift/${P}.tar.bz2"
RESTRICT="nomirror"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"

DEPEND="virtual/libc
	dev-util/pkgconfig
	berkdb? ( >=sys-libs/db-3.3 )"

RDEPEND=">=net-p2p/gift-0.11.8
	>=sys-libs/zlib-1.1.4
	berkdb? ( >=sys-libs/db-3.3 )"

src_compile() {
	econf `use_enable berkdb libdb` || die "failed to configure"
	emake || die "failed to build"
}

src_install() {
	einstall giftconfdir=${D}/etc/giFT \
		 plugindir=${D}/usr/lib/giFT \
		 datadir=${D}/usr/share/giFT \
		 giftperldir=${D}/usr/bin \
		 libgiftincdir=${D}/usr/include/libgift || die "Install failed"
	dodoc README NEWS ChangeLog TODO
}

pkg_postinst() {
	if ! use berkdb; then
		ewarn "To become a search node, you must have berkdb set"
		ewarn "in your USE flags."
		echo
	fi
	einfo "It is recommended that you re-run gift-setup as"
	einfo "the user you will run the giFT daemon as:"
	einfo "\tgift-setup"
	echo
	einfo "Alternatively you can add the following line to"
	einfo "your ~/.giFT/giftd.conf configuration file:"
	einfo "plugins = OpenFT"
}
