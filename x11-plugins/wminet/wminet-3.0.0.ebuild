# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wminet/wminet-3.0.0.ebuild,v 1.4 2008/06/28 07:02:13 maekke Exp $

inherit toolchain-funcs

DESCRIPTION="dockapp for monitoring internet connections to and from your computer."
HOMEPAGE="http://www.swanson.ukfsn.org/#wminet"
SRC_URI="http://www.swanson.ukfsn.org/wmdock/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_compile() {
	tc-export CC
	econf
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README wminetrc
}
