# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-pango/ruby-pango-0.8.0.ebuild,v 1.4 2004/07/14 22:14:31 agriffis Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="alpha x86 ia64"
IUSE=""
DEPEND="${DEPEND} >=x11-libs/pango-1.2.1"
RDEPEND="${RDEPEND} >=x11-libs/pango-1.2.1 >=dev-ruby/ruby-glib2-${PV}"
