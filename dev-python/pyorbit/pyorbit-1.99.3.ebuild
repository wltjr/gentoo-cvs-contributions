# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyorbit/pyorbit-1.99.3.ebuild,v 1.4 2003/06/21 22:30:25 drobbins Exp $

# debug since its a devel release
inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="ORBit2 bindings for Python"
HOMEPAGE="http://www.daa.com.au/~james/pygtk/"
LICENSE="LGPL-2.1"

DEPEND=">=dev-lang/python-2.2
	>=gnome-base/ORBit2-2.4.4"

SLOT="0"
RDEPEND="${DEPEND} >=dev-util/pkgconfig-0.12.0"
KEYWORDS="x86 amd64 ~ppc"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
