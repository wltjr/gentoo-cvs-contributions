# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/glademm/glademm-2.0.0.ebuild,v 1.9 2004/06/25 02:33:22 agriffis Exp $

inherit gnome2

DESCRIPTION="A C++ code generating backend for glade"
HOMEPAGE="http://home.wtal.de/petig/Gtk/"
SRC_URI="http://home.wtal.de/petig/Gtk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc"
IUSE=""

DEPEND="virtual/glibc"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO docs/*"

pkg_postinst() {
	einfo "glademm generated sources have dependencies on packages not required by this ebuild."
}
