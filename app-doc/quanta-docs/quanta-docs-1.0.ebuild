# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/quanta-docs/quanta-docs-1.0.ebuild,v 1.16 2004/06/24 21:49:59 agriffis Exp $

S=${WORKDIR}
DESCRIPTION="Lots of docs for quanta"
SRC_URI="mirror://sourceforge/quanta/quanta-css-${PV}.tar.bz2
	mirror://sourceforge/quanta/quanta-html-${PV}.tar.bz2
	mirror://sourceforge/quanta/quanta-javascript-${PV}.tar.bz2
	mirror://sourceforge/quanta/quanta-php-${PV}.tar.bz2"
HOMEPAGE="http://quanta.sourceforge.net"

SLOT="0"
IUSE=""
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc amd64"

src_install() {
	dodir /usr/share/apps/quanta/doc
	for i in css html javascript php ; do
		cd ${S}/${i}
		cp -R $i $i.docrc ${D}/usr/share/apps/quanta/doc
	done
}
