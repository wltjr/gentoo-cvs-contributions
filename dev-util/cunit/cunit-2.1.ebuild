# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cunit/cunit-2.1.ebuild,v 1.3 2008/08/01 14:41:37 hattya Exp $

inherit eutils autotools

MY_PN='CUnit'
MY_PV="${PV}-0"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="CUnit - C Unit Test Framework"
SRC_URI="mirror://sourceforge/cunit/${MY_P}-src.tar.gz"
HOMEPAGE="http://cunit.sourceforge.net"

DEPEND="virtual/libc"
SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	eautoreconf
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "make install failed"
	dodoc AUTHORS INSTALL NEWS README ChangeLog
}
