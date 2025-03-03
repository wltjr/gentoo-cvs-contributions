# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-gamma/gkrellm-gamma-2.03-r1.ebuild,v 1.7 2008/07/28 13:46:41 lack Exp $

inherit gkrellm-plugin

IUSE=""
DESCRIPTION="A gamma control plugin for gkrellm"
HOMEPAGE="http://sweb.cz/tripie/gkrellm/gamma/"
SRC_URI="http://sweb.cz/tripie/gkrellm/gamma/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="ppc sparc x86"

DEPEND="x11-libs/libXxf86vm
	x11-proto/xf86vidmodeproto"

RDEPEND="x11-libs/libXxf86vm"

PLUGIN_SO=gamma.so
PLUGIN_DOCS="doc/ChangeLog"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Fix the TEXTREL error, by linking with the shared version of libXxf86vm
	# instead of the static
	sed -i -e 's:/usr/X11R6/lib/libXxf86vm.a::' Makefile || die "sed 1/2 failed"
	sed -i -e '/^LIBS/aLIBS += -L/usr/lib -L/usr/X11R6/lib -lXxf86vm' Makefile || die "sed 2/2 failed"
}
