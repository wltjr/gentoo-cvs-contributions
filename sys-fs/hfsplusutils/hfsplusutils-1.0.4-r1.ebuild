# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/hfsplusutils/hfsplusutils-1.0.4-r1.ebuild,v 1.16 2008/02/05 03:09:46 wolf31o2 Exp $

WANT_AUTOMAKE=1.6
inherit autotools eutils libtool

MY_P="hfsplus_${PV}"
DESCRIPTION="HFS+ Filesystem Access Utilities (a PPC filesystem)"
HOMEPAGE="http://penguinppc.org/historical/hfsplus/"
SRC_URI="http://penguinppc.org/historical/hfsplus/${MY_P}.src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="app-arch/bzip2"
RDEPEND="virtual/libc"

S=${WORKDIR}/hfsplus-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-glob.patch"
	epatch "${FILESDIR}/${P}-errno.patch"
	epatch "${FILESDIR}/${P}-gcc4.patch"
	epatch "${FILESDIR}/${P}-string.patch"
	#let's avoid the Makefile.cvs since isn't working for us
	AM_OPTS="-a" eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	newman doc/man/hfsp.man hfsp.1
}
