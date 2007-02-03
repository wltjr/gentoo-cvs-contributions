# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.16.2.ebuild,v 1.11 2007/02/03 21:57:36 ticho Exp $

inherit gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
IUSE="beagle"

RDEPEND=">=gnome-base/gconf-2
	>=app-text/gnome-doc-utils-0.3.1
	>=x11-libs/gtk+-2.10
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2.14
	>=dev-libs/libxml2-2.6.5
	>=dev-libs/libxslt-1.1.4
	>=x11-libs/startup-notification-0.8
	>=dev-libs/glib-2
	|| ( >=dev-libs/dbus-glib-0.71
		( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.30 ) )
	beagle? ( >=app-misc/beagle-0.2.4 )
	!sh? ( >=www-client/mozilla-firefox-1.0.2-r1 )
	sys-libs/zlib
	app-arch/bzip2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --enable-man --enable-info --with-mozilla=firefox"
}
