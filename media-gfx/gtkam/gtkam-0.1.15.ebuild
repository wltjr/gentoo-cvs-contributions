# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gtkam/gtkam-0.1.15.ebuild,v 1.2 2008/05/17 19:20:24 armin76 Exp $

inherit autotools eutils gnome2

DESCRIPTION="A frontend for gPhoto 2"
HOMEPAGE="http://gphoto.org/proj/gtkam"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="gimp gnome nls"

# FIXME: why is exif not optional ?

RDEPEND=">=x11-libs/gtk+-2.0
	>media-libs/libgphoto2-2.4
	>=media-libs/libexif-0.3.2
	media-libs/libexif-gtk
	gimp? ( >=media-gfx/gimp-2 )
	gnome? (
		>=gnome-base/libbonobo-2
		>=gnome-base/libgnomeui-2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-text/scrollkeeper
	nls? ( >=sys-devel/gettext-0.14.1 )"

DOCS="AUTHORS CHANGES NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_with gimp)
		$(use_with gnome)
		$(use_with gnome bonobo)
		$(use_enable nls)
		--disable-scrollkeeper
		--with-rpmbuild=/bin/false"
}

src_unpack() {
	gnome2_src_unpack

	# Fix --as-needed, bug #169661
	epatch "${FILESDIR}/${PN}-0.1.14-as-needed.patch"

	eautomake
}

src_install() {
	gnome2_src_install

	rm -rf "${D}"/usr/share/doc/gtkam
}
