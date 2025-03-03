# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/d-feet/d-feet-0.1.4.ebuild,v 1.1 2007/12/13 20:41:12 cardoe Exp $

inherit distutils gnome2-utils

DESCRIPTION="D-Feet is a powerful D-Bus debugger"
HOMEPAGE="http://hosted.fedoraproject.org/projects/d-feet/"
SRC_URI="http://johnp.fedorapeople.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-apps/dbus-1.0
	>=dev-python/dbus-python-0.82.3
	dev-python/pygtk
	>=dev-lang/python-2.5"

pkg_setup() {
	PYTHON_MODNAME="dfeet"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-show-properties.patch
}

pkg_postinst()
{
	distutils_pkg_postinst
	gnome2_icon_cache_update
}
