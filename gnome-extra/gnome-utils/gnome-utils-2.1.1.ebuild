# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-utils/gnome-utils-2.1.1.ebuild,v 1.1 2002/10/27 15:06:11 foser Exp $

inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="Utilities for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64 ppc alpha"

RDEPEND=">=dev-libs/glib-2.0.6
	=x11-libs/pango-1.1*
	=dev-libs/atk-1.1*
	=x11-libs/gtk+-2.1*
	>=app-text/scrollkeeper-0.3.11
	>=media-libs/freetype-2.0.9
	>=x11-libs/libzvt-2.0.1
	>=gnome-base/libglade-2.0.1
	>=gnome-base/gconf-1.2.1
	=gnome-base/libgnomeui-2.1*
	=gnome-base/gnome-panel-2.1*
	>=gnome-base/gnome-vfs-2.0.4
	>=gnome-base/ORBit2-2.4.3
	>=gnome-base/libbonoboui-2.0
	=gnome-base/libgnomecanvas-2.1*
	=gnome-base/bonobo-activation-2.1*
	=gnome-extra/libgtkhtml-2.1*
	>=dev-libs/libxml2-2.4.25
	>=sys-libs/ncurses-5.2-r5
	>=gnome-base/libgtop-2.0.0
	>=net-libs/linc-0.5.4"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.22
	>=dev-util/pkgconfig-0.12.0"

G2CONF="${G2CONF} --disable-guname-capplet --enable-gcolorsel-applet --with-ncurses --enable-gdialog"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS  README* THANKS"

		
