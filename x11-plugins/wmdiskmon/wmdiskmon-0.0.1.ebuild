# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmdiskmon/wmdiskmon-0.0.1.ebuild,v 1.11 2008/01/15 07:56:35 drac Exp $

DESCRIPTION="a dockapp to display disk space usage."
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"
SRC_URI="http://tnemeth.free.fr/projets/programmes/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-libs/libXt"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog THANKS TODO
}
