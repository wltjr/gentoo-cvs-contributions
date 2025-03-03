# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/libbtctl/libbtctl-0.10.0.ebuild,v 1.2 2008/04/17 19:31:54 jer Exp $

inherit gnome2 multilib mono autotools

DESCRIPTION="A GObject wrapper for Bluetooth functionality"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="mono doc"

RDEPEND=">=dev-libs/glib-2
	>=net-wireless/bluez-utils-2.25
	>=net-wireless/bluez-libs-2.25
	>=dev-libs/openobex-1.2
	>=dev-lang/python-2.3
	>=dev-python/pygtk-2.0
	!sparc? (
		mono? (
			>=dev-lang/mono-0.96
			=dev-dotnet/gtk-sharp-1.0*
		)
	)"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	dev-util/pkgconfig
	doc? ( dev-util/gtk-doc )"

MAKEOPTS="${MAKEOPTS} -j1"
DOCS="README NEWS ChangeLog AUTHORS COPYING"

src_unpack() {
	gnome2_src_unpack

	# Fix multilib
	sed -e "s:\/lib\/:\/$(get_libdir)\/:" -i src/Makefile.am

	# Fix tests (needed with eautoreconf)
	intltoolize --force
	eautoreconf
}

pkg_setup() {
	use sparc || G2CONF="${G2CONF} $(use_enable mono)"
}

src_compile() {
	sed -i -e 's/libext="a/& la/' libtool

	gnome2_src_compile
}
