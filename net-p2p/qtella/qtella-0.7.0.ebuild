# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qtella/qtella-0.7.0.ebuild,v 1.2 2004/06/25 00:36:13 agriffis Exp $

inherit kde-base

IUSE="kde"
use kde && need-kde 3 || need-qt 3

SRC_URI="mirror://sourceforge/qtella/${P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://www.qtella.net"
DESCRIPTION="Excellent QT/KDE Gnutella Client"

SLOT="3" # why??
LICENSE="GPL-2"
#masking by keywords as there are known bugs and I don't want to put up with the reports yet
KEYWORDS="~x86 ~ppc"
export MAKEOPTS="$MAKEOPTS -j1"

src_compile() {
	kde_src_compile myconf
	use kde || myconf="$myconf --with-kde=no"
	kde_src_compile configure make
}
