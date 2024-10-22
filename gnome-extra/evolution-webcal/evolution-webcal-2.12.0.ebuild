# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-webcal/evolution-webcal-2.12.0.ebuild,v 1.9 2008/04/01 21:06:01 leio Exp $
EAPI="1"

inherit eutils gnome2

DESCRIPTION="A GNOME URL handler for web-published ical calendar files"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=gnome-base/gconf-2
	net-libs/libsoup:2.2
	>=dev-libs/glib-2.8
	>=x11-libs/gtk+-2.4
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2
	>=gnome-extra/evolution-data-server-1.2"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog TODO"
USE_DESTDIR="1"

src_unpack() {
	gnome2_src_unpack

	# Fix build with libsoup-2.4 present on the system
	epatch "${FILESDIR}/${P}-no-libsoup24.patch"
}
