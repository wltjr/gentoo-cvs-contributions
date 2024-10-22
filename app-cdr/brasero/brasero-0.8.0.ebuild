# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/brasero/brasero-0.8.0.ebuild,v 1.1 2008/07/16 12:33:41 loki_val Exp $

EAPI=1

GCONF_DEBUG=no

inherit gnome2

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://www.gnome.org/projects/brasero"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="beagle +dvd gdl +libburn totem"

RDEPEND=">=dev-libs/glib-2.15.6
	>=x11-libs/gtk+-2.12.0
	>=gnome-base/libgnome-2.22.0
	>=gnome-base/libgnomeui-2.22.0
	>=media-libs/gstreamer-0.10.15
	>=media-libs/gst-plugins-base-0.10.15
	>=media-plugins/gst-plugins-ffmpeg-0.10
	>=dev-libs/libxml2-2.6
	sys-apps/hal
	gnome-base/gvfs
	app-cdr/cdrdao
	virtual/cdrtools
	>=dev-libs/dbus-glib-0.7.2
	dvd? ( media-libs/libdvdcss
		app-cdr/dvd+rw-tools )
	gdl? ( >=dev-libs/gdl-0.6 )
	totem? ( >=dev-libs/totem-pl-parser-2.20 )
	beagle? ( >=dev-libs/libbeagle-0.3.0 )
	libburn? ( >=dev-libs/libburn-0.4.0
		>=dev-libs/libisofs-0.6.4 )"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper
		--disable-caches
		--disable-dependency-tracking
		$(use_enable totem playlist)
		$(use_enable beagle search)
		$(use_enable libburn libburnia)"

	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	elog "To use the libburn backend you need to add USE=libburn and activate"
	elog "it in gconf editor. Note that the default backend is cdrtools/cdrkit."
	echo
}
