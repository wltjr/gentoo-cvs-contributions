# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-pango/ruby-pango-0.9.1.ebuild,v 1.4 2004/06/29 18:06:33 usata Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="alpha x86 ppc ~ia64"
USE_RUBY="ruby18 ruby19"	# ruby16 is not supported
DEPEND="${DEPEND} >=x11-libs/pango-1.2.1"
RDEPEND="${RDEPEND} >=x11-libs/pango-1.2.1 >=dev-ruby/ruby-glib2-${PV}"
