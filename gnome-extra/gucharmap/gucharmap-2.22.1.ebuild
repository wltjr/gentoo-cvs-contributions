# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gucharmap/gucharmap-2.22.1.ebuild,v 1.1 2008/04/07 20:55:26 leio Exp $

inherit gnome2 eutils

DESCRIPTION="Unicode character map viewer"
HOMEPAGE="http://gucharmap.sourceforge.net/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cjk gnome"

# gnome-base/libgnome is still used as "exec gnome-open", but our non-GNOME friends
# would probably prefer non-working help button over a libgnome dependency, while
# GNOME will have libgnome pulled in by other stuff still either way. Reconsider
# once libgnome can truely die (gnome 2.24 material)
RDEPEND=">=dev-libs/glib-2.3
	>=x11-libs/pango-1.2.1
	>=x11-libs/gtk+-2.12
	gnome? ( gnome-base/gconf )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.3.2"

DOCS="ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		$(use_enable gnome gconf)
		$(use_enable cjk unihan)"
}
