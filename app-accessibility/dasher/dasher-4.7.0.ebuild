# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/dasher/dasher-4.7.0.ebuild,v 1.1 2008/03/29 21:37:30 eva Exp $

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.8"

inherit autotools eutils gnome2

DESCRIPTION="A text entry interface, driven by continuous pointing gestures"
HOMEPAGE="http://www.inference.phy.cam.ac.uk/dasher/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="accessibility cairo gnome"

# The package claims to support 'qte', but it hasn't been tested.
# Any patches from someone who can test it are welcome.
# <leonardop@gentoo.org>
RDEPEND=">=dev-libs/glib-2.6
	dev-libs/expat
	>=x11-libs/gtk+-2.6
	>=gnome-base/gconf-2
	>=gnome-base/libglade-2
	gnome? (
		>=gnome-base/libgnome-2
		>=gnome-base/libgnomeui-2
		>=gnome-base/gnome-vfs-2 )
	accessibility? (
		app-accessibility/gnome-speech
		>=gnome-base/libbonobo-2
		>=gnome-base/orbit-2
		>=gnome-base/libgnomeui-2
		>=gnome-extra/at-spi-1
		dev-libs/atk )
	cairo? ( >=x11-libs/gtk+-2.8 )
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXt"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	gnome? (
		>=app-text/gnome-doc-utils-0.3.2
		app-text/scrollkeeper )
	x11-proto/xextproto
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	# we might want to support japanese and chinese input at some point
	# --enable-japanese
	# --enable-chinese
	# --enable-tilt (tilt sensor support)

	G2CONF="--disable-scrollkeeper
		$(use_enable accessibility a11y)
		$(use_enable accessibility speech)
		$(use_with cairo)
		$(use_with gnome)"
}

src_unpack() {
	gnome2_src_unpack

	sed -i -e 's:gtk-update-icon-cache:true:' ./Data/Makefile.am

	# Fix build with --as-needed (upstream bug #525028)
	epatch "${FILESDIR}/${PN}-4.7.0-as-needed.patch"

	# Patches to fix compilation when USE=-gnome is used
	# (bug #165154 and bug #189307)
	epatch "${FILESDIR}/${PN}-4.4.0-gnome_help.patch"
	epatch "${FILESDIR}/${PN}-4.6.1-gnome.patch"

	# Fix compilation with glibc-2.5
	epatch "${FILESDIR}/${PN}-4.6.1-lldiv.patch"

	# Fix tests (upstream bug #525035)
	echo "Data/dasher.desktop.in" >> po/POTFILES.in

	eautoreconf
	intltoolize --force || die "intltoolize failed"
}
