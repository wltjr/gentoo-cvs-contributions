# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/cellwriter/cellwriter-1.3.1.ebuild,v 1.2 2008/01/15 00:53:19 maekke Exp $

DESCRIPTION="Grid-entry natural handwriting input panel"
HOMEPAGE="http://risujin.org/cellwriter/"
SRC_URI="http://pub.risujin.org/cellwriter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

RDEPEND="x11-libs/libXtst
	>=x11-libs/gtk+-2.10
	gnome? ( gnome-base/libgnome )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-proto/inputproto"

src_compile() {
	econf $(use_with gnome) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README
}
