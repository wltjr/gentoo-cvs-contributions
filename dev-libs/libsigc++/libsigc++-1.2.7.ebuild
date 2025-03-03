# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libsigc++/libsigc++-1.2.7.ebuild,v 1.1 2008/05/21 13:46:37 remi Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.7"

inherit autotools gnome2

DESCRIPTION="Typesafe callback system for standard C++"
HOMEPAGE="http://libsigc.sourceforge.net/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="1.2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="debug"

RDEPEND=""

DOCS="AUTHORS ChangeLog FEATURES IDEAS README INSTALL NEWS TODO"

pkg_config() {
	use debug \
		&& G2CONF="--enable-debug=yes" \
		|| G2CONF="--enable-debug=no"

	G2CONF="${G2CONF} --enable-maintainer-mode --enable-threads"
}

src_unpack() {
	gnome2_src_unpack

	# fixes bug #219041
	sed -e 's:ACLOCAL_AMFLAGS = -I $(srcdir)/scripts:ACLOCAL_AMFLAGS = -I scripts:' \
		-i Makefile.{in,am}

	eautoreconf
}
