# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xsane/xsane-0.86-r1.ebuild,v 1.9 2004/04/30 14:47:04 lu_zero Exp $

DESCRIPTION="graphical scanning frontend"
SRC_URI="http://www.xsane.org/download/${P}.tar.gz"
HOMEPAGE="http://www.xsane.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"
IUSE="nls jpeg png tiff"

DEPEND="media-gfx/sane-backends
	=x11-libs/gtk+-1.2*"

src_compile() {
	econf \
		`use_enable nls` \
		`use_enable jpeg` \
		`use_enable png` \
		`use_enable tiff` \
		|| die
	make || die
}

src_install() {
	einstall || die
	dodoc xsane.[A-Z]*
	dohtml -r doc

	# link xsane so it is seen as a plugin in gimp
	if [ -d /usr/lib/gimp/1.2 ]; then
		dodir /usr/lib/gimp/1.2/plug-ins
		dosym /usr/bin/xsane /usr/lib/gimp/1.2/plug-ins
	fi
	if [ -d /usr/lib/gimp/1.3 ]; then
		dodir /usr/lib/gimp/1.3/plug-ins
		dosym /usr/bin/xsane /usr/lib/gimp/1.3/plug-ins
	fi
}
