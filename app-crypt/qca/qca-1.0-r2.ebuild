# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-1.0-r2.ebuild,v 1.19 2008/07/27 19:14:20 carlo Exp $

EAPI=1

inherit eutils qt3

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="x11-libs/qt:3"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/qca-pathfix.patch
	#This is needed just in bsd, but make no harm in linux
	epatch "${FILESDIR}"/qca-1.0-fbsd.patch
}

src_compile() {
	./configure --prefix=/usr || die "configure failed"
	sed -i \
		-e "/^CFLAGS/s:$: ${CFLAGS}:" \
		-e "/^CXXFLAGS/s:$: ${CXXFLAGS}:" \
		-e "/-strip/d" \
		Makefile
	emake || die "emake failed"
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "make install failed"
	if [ "$(get_libdir)" != "lib" ]; then
		mv "${D}"/usr/lib "${D}"/usr/$(get_libdir)
	fi
}
