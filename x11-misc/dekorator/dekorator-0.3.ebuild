# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/dekorator/dekorator-0.3.ebuild,v 1.1 2006/03/25 20:04:35 vanquirius Exp $

inherit kde

DESCRIPTION="DeKorator is a native window style for KDE 3.2+"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=31447"
SRC_URI="mirror://gentoo/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

need-kde 3.3

pkg_postinst() {
	einfo "To use deKorator, open KDE's Control Center, go to"
	einfo "Appearance & Themes, select Window Decorations,"
	einfo "deKorator. For more information, see"
	einfo "${HOMEPAGE}"
}
