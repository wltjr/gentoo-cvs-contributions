# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/gnome-terminal/gnome-terminal-2.4.2.ebuild,v 1.12 2005/01/08 23:38:02 slarti Exp $

inherit gnome2 eutils

DESCRIPTION="The Gnome Terminal"
IUSE=""
HOMEPAGE="http://www.gnome.org/"
KEYWORDS="x86 ppc alpha sparc hppa amd64 ia64 mips"
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2.2
	>=gnome-base/libglade-2
	>=gnome-base/gconf-1.2
	>=gnome-base/libgnomeui-2
	>=x11-libs/startup-notification-0.4
	>=x11-libs/vte-0.11"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/pkgconfig-0.12.0
	!gnome-base/gnome-core"
# gnome-core overwrite /usr/bin/gnome-terminal

src_unpack() {
	unpack ${A}
	cd ${S}

	# Use login shell by default (#12900) 
	epatch ${FILESDIR}/${PN}-2-default_shell.patch

	# terminal enhancement, inserts a space after a DND URL
	# patch by Zach Bagnall <yem@y3m.net> in #13801
	epatch ${FILESDIR}/${PN}-2-dnd_url_add_space.patch

	# Enable keyboard shortcuts when the menubar is not visible.
	epatch ${FILESDIR}/${P}-shortcuts_fix.patch
}

DOCS="AUTHORS ChangeLog COPYING README INSTALL NEWS TODO"
