# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtk2/ruby-gtk2-0.8.0.ebuild,v 1.4 2004/07/14 22:09:53 agriffis Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby Gtk2 bindings"
KEYWORDS="alpha x86 ia64"
IUSE=""
DEPEND="${DEPEND} >=x11-libs/gtk+-2"
RDEPEND="${RDEPEND} >=x11-libs/gtk+-2
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gdkpixbuf2-${PV}
	>=dev-ruby/ruby-pango-${PV}"
