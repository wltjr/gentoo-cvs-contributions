# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmlpq/wmlpq-0.2.1-r1.ebuild,v 1.2 2006/01/15 17:47:42 nelchael Exp $

inherit eutils

IUSE=""

DESCRIPTION="Windowmaker dockapp which monitors up to 5 printqueues"
SRC_URI="http://www.ur.uklinux.net/wmlpq/dl/wmlpq_0.2.1.tar.gz"
HOMEPAGE="http://www.ur.uklinux.net/wmlpq/"

DEPEND="x11-libs/libdockapp"

RDEPEND=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

src_unpack()
{
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-makefile.patch
}

src_install()
{
	dodir /usr/bin/
	einstall DESTDIR=${D}/usr/bin/ CFLAGS="${CFLAGS} -Wall" || die "Installation failed"

	dodoc README sample.wmlpqrc
	newman wmlpq.1x wmlpq.1

	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop
}
