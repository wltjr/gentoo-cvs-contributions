# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/adasockets/adasockets-1.7-r1.ebuild,v 1.5 2003/10/06 00:09:46 dholm Exp $

inherit gnat

DESCRIPTION="An Interface to BSD sockets from Ada (TCP, UDP and multicast)."
SRC_URI="http://www.rfc1149.net/download/adasockets/${P}.tar.gz"
HOMEPAGE="http://www.rfc1149.net/devel/adasockets/"
LICENSE="GMGPL"

DEPEND="dev-lang/gnat"
RDEPEND=""
SLOT="0"
IUSE=""
KEYWORDS="x86 ~ppc"

src_compile() {
	econf --libdir=/usr/lib/ada/adalib \
		--includedir=/usr/lib/ada/adainclude || die "./configure failed"
	sed -i -e "s|-I\$libdir|-I/usr/lib/ada/adainclude|" src/adasockets-config.in

	emake || die
}

src_install () {
	cd ${S}
	#doins copies symlinks as regular files, resorting to manual cp
	dodir /usr/lib/ada/adalib/adasockets
	cp -d src/.libs/lib*.so* ${D}/usr/lib/ada/adalib/adasockets
	chmod 0755 ${D}/usr/lib/ada/adalib/adasockets/lib*.so*
	dosym /usr/lib/ada/adalib/adasockets/libadasockets.so /usr/lib
	dosym /usr/lib/ada/adalib/adasockets/libadasockets.so.0 /usr/lib
	dosym /usr/lib/ada/adalib/adasockets/libadasockets.so.0.0.0 /usr/lib
	insinto /usr/lib/ada/adalib/adasockets
	doins src/.libs/lib*.a
	chmod 0644 ${D}/usr/lib/ada/adalib/adasockets/lib*.a
	doins src/sockets*.ali

	insinto /usr/lib/ada/adainclude/adasockets
	doins src/sockets*.ads

	dodoc AUTHORS COPYING INSTALL NEWS README
	dodoc doc/adasockets.pdf doc/adasockets.ps
	doinfo doc/adasockets.info
	doman man/adasockets-config.1
	dobin src/adasockets-config
}
