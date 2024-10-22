# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kickpim/kickpim-0.5.3.ebuild,v 1.9 2004/12/31 06:00:21 weeve Exp $

inherit kde eutils

DESCRIPTION="A KDE panel applet for editing and accessing the KDE Addressbook."
SRC_URI="mirror://sourceforge/kickpim/${P}.tar.bz2"
HOMEPAGE="http://kickpim.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~sparc"
IUSE=""

need-kde 3

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/${P}-fPIC.patch
	epatch ${FILESDIR}/${P}-gcc3.4.patch
}
