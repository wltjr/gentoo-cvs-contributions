# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dietlibc/dietlibc-0.31_pre20070503.ebuild,v 1.2 2007/05/22 16:06:53 phreak Exp $

inherit eutils flag-o-matic

DESCRIPTION="A minimal libc"
HOMEPAGE="http://www.fefe.de/dietlibc/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~phreak/distfiles/${PN}-patches-${PVR}.tar.bz2
	http://dev.gentoo.org/~hollow/distfiles/${PN}-patches-${PVR}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

DEPEND=""

pkg_setup() {
	# Replace sparc64 related C[XX]FLAGS (see bug #45716)
	use sparc && replace-sparc64-flags

	# gcc-hppa suffers support for SSP, compilation will fail
	use hppa && strip-unsupported-flags

	# debug flags
	use debug && append-flags -g
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/patches/*.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dobin "${D}"/usr/diet/bin/* || die "dobin failed"
	doman "${D}"/usr/diet/man/*/* || die "doman failed"
	rm -r "${D}"/usr/diet/{man,bin}
	dodoc AUTHOR BUGS CAVEAT CHANGES README THANKS TODO PORTING
}
