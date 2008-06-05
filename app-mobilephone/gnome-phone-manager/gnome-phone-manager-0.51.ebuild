# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/gnome-phone-manager/gnome-phone-manager-0.51.ebuild,v 1.1 2008/06/05 21:50:54 eva Exp $

inherit gnome2

DESCRIPTION="a program created to allow you to control aspects of your mobile phone from your GNOME 2 desktop"
HOMEPAGE="http://live.gnome.org/PhoneManager"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
# telepathy support is considered experimental

RDEPEND=">=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2
	>=dev-libs/glib-2
	>=media-libs/gstreamer-0.10
	>=gnome-base/orbit-2
	>=dev-libs/openobex-1
	>=app-mobilephone/gnokii-0.6.24
	>=net-wireless/bluez-libs-3.12
	>=gnome-base/libglade-2
	>=gnome-extra/evolution-data-server-1.2.3
	>net-wireless/gnome-bluetooth-0.8
	>=dev-libs/dbus-glib-0.71
	>=x11-themes/gnome-icon-theme-2.19.1
	>=app-text/gtkspell-2"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	dev-util/pkgconfig"

DOCS="README NEWS AUTHORS ChangeLog"

pkg_setup() {
	G2CONF="${G2CONF} --disable-telepathy"
}
