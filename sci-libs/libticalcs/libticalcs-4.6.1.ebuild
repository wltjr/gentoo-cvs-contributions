# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libticalcs/libticalcs-4.6.1.ebuild,v 1.2 2007/07/13 06:57:50 mr_bones_ Exp $

DESCRIPTION="Calculator API for the TiLP calculator linking program"
HOMEPAGE="http://tilp.info/"
#SRC_URI="mirror://sourceforge/tilp/${P}.tar.gz"
SRC_URI="http://nico.hibou.free.fr/hibnet/gentoo/distfiles/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="nls"

RDEPEND=">=sci-libs/libticables-3.6.1
	>=sci-libs/libtifiles-0.6.1
	virtual/libc
	nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND}
	sys-devel/bison"

src_compile() {
	local myconf="$(use_enable nls)"
	econf ${myconf} || die

	# Install "po" files in ${D} rather than to the root dir.
	cd ${S}/po
	sed -i -e 's:prefix = /usr:prefix = $(D)/usr:' Makefile
	cd ${S}

	emake || die
}

src_install() {
	make install DESTDIR=${D}
	dodoc AUTHORS COPYING LOGO NEWS README
}
