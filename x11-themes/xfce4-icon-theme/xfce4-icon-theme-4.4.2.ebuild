# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/xfce4-icon-theme/xfce4-icon-theme-4.4.2.ebuild,v 1.1 2008/06/22 22:22:38 drac Exp $

inherit gnome2-utils

DESCRIPTION="Default icon theme for Xfce4, called Rodent."
HOMEPAGE="http://www.xfce.org"
SRC_URI="mirror://xfce/xfce-${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RESTRICT="binchecks strip"

RDEPEND="x11-themes/hicolor-icon-theme"
DEPEND="dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
