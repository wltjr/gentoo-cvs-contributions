# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libtifiles/libtifiles-0.6.1.ebuild,v 1.4 2005/03/11 11:48:24 sekretarz Exp $

DESCRIPTION="Various TI file formats support for the TiLP calculator linking program"
HOMEPAGE="http://tilp.info/"
SRC_URI="mirror://sourceforge/tilp/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE="nls"

RDEPEND="sci-libs/libticables
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
	dodoc AUTHORS ChangeLog LOGO README
}
