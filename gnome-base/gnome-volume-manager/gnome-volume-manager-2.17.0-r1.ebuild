# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-volume-manager/gnome-volume-manager-2.17.0-r1.ebuild,v 1.10 2008/06/05 11:55:09 remi Exp $

inherit gnome2 eutils autotools

DESCRIPTION="Daemon that enforces volume-related policies"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="crypt debug doc"

RDEPEND="gnome-base/nautilus
	>=gnome-base/libgnomeui-2.1.5
	>=dev-libs/dbus-glib-0.71
	>=sys-apps/hal-0.5.6
	>=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2
	>=x11-libs/libnotify-0.3
	>=gnome-base/gconf-2
	>=gnome-base/gnome-control-center-2.0
	gnome-base/gnome-mime-data
	gnome-base/gnome-mount"

DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog README HACKING NEWS TODO"

pkg_setup() {
	G2CONF="${G2CONF} \
			$(use_enable crypt) \
			$(use_enable debug) \
			$(use_enable doc)"

	# FIXME: We should be more intelligent about disabling multiuser support
	# (like enable it when pam_console is available?). For now, this is a
	# slightly nicer solution than applying ${PN}-1.5.9-no-pam_console.patch
	G2CONF="${G2CONF} --disable-multiuser"
}

src_unpack() {
	gnome2_src_unpack

	# fbsd fixes.  bug #183442
	epatch "${FILESDIR}"/${P}-fbsd.patch

	# Fix default totem command.  Bug #200999
	epatch "${FILESDIR}"/${P}-totem-dvd.patch

	# fix LINGUAS handling, bug #183086
	intltoolize --force || die "intltoolize failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To start the gnome-volume-manager daemon you need to configure"
	elog "it through it's preferences capplet. Also the HAL daemon (hald)"
	elog "needs to be running or it will shut down."
}
