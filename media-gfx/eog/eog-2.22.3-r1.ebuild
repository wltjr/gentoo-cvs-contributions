# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/eog/eog-2.22.3-r1.ebuild,v 1.1 2008/07/23 20:28:28 ford_prefect Exp $

inherit eutils gnome2

DESCRIPTION="The Eye of GNOME image viewer"
HOMEPAGE="http://www.gnome.org/projects/eog/"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dbus exif lcms python"

# FIXME: add exempi to the tree ?

RDEPEND=">=x11-libs/gtk+-2.11.6
	>=dev-libs/glib-2.15.3
	>=gnome-base/gnome-vfs-2.10
	>=gnome-base/libgnomeui-2.10
	>=gnome-base/libglade-2.3.6
	>=gnome-base/gconf-2.5.90
	>=media-libs/libart_lgpl-2.3.16
	>=gnome-base/gnome-desktop-2.10
	>=x11-themes/gnome-icon-theme-2.19.1
	>=x11-misc/shared-mime-info-0.20
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	exif? (
		>=media-libs/libexif-0.6.14
		media-libs/jpeg )
	lcms? ( media-libs/lcms )
	python? (
		>=dev-lang/python-2.3
		>=dev-python/pygobject-2.11.5
		>=dev-python/pygtk-2.9.7
		>=dev-python/gnome-python-2.18.2
	)"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.17"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README THANKS TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_with exif libjpeg)
		$(use_with exif libexif)
		$(use_with dbus dbus-glib-1)
		$(use_with lcms cms)
		$(use_enable python)
		--without-xmp
		--disable-scrollkeeper"
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! built_with_use =x11-libs/gtk+-2* jpeg; then
		ewarn "For JPEG file support to work, x11-libs/gtk+ must be rebuilt"
		ewarn "with the 'jpeg' USE flag enabled."
	fi

	if ! built_with_use =x11-libs/gtk+-2* tiff; then
		ewarn "For TIFF file support to work, x11-libs/gtk+ must be rebuilt"
		ewarn "with the 'tiff' USE flag enabled."
	fi
}
