# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4-session/xfce4-session-4.1.99.2.ebuild,v 1.2 2004/12/17 06:27:54 bcowan Exp $

IUSE=""
DESCRIPTION="Xfce 4 session manager"
SRC_URI="http://www.xfce.org/archive/xfce-${PV}/src/${P}.tar.gz"
HOMEPAGE="http://xfce.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="virtual/x11
	>=x11-libs/gtk+-2.2*
	dev-libs/libxml2
	=xfce-base/libxfce4util-${PV}
	=xfce-base/libxfcegui4-${PV}
	=xfce-base/libxfce4mcs-${PV}
	=xfce-base/xfce-utils-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf || die
	emake -j1 || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog* AUTHORS README* TODO*
}