# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/tsocks/tsocks-1.8_beta5-r2.ebuild,v 1.7 2007/04/22 08:26:07 kloeri Exp $

inherit multilib eutils autotools toolchain-funcs

DESCRIPTION="Transparent SOCKS v4 proxying library"
HOMEPAGE="http://tsocks.sourceforge.net/"
SRC_URI="mirror://sourceforge/tsocks/${PN}-${PV/_}.tar.gz
	tordns? ( mirror://gentoo/${PN}-${PV/_beta/b}-tordns1-gentoo.patch.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="tordns"

S="${WORKDIR}/${P%%_*}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-bsd.patch"
	use tordns && epatch "../${PN}-${PV/_beta/b}-tordns1-gentoo.patch"
	eautoconf
}

src_compile() {
	tc-export CC

	# NOTE: the docs say to install it into /lib. If you put it into
	# /usr/lib and add it to /etc/ld.so.preload on many systems /usr isn't
	# mounted in time :-( (Ben Lutgens) <lamer@gentoo.org>
	econf \
		--with-conf=/etc/socks/tsocks.conf \
		--libdir=/$(get_libdir) || die "configure failed"
	# Fix QA notice lack of SONAME
	emake DYNLIB_FLAGS=-Wl,--soname,libtsocks.so.${PV/_beta*} || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	newbin validateconf tsocks-validateconf
	newbin saveme tsocks-saveme
	dobin inspectsocks
	insinto /etc/socks
	doins tsocks.conf.*.example
	dodoc FAQ
	use tordns && dodoc README*
	# tsocks script is buggy so we need this symlink
	dodir /usr/$(get_libdir)
	dosym /$(get_libdir)/libtsocks.so /usr/$(get_libdir)/libtsocks.so
}

pkg_postinst() {
	einfo "Make sure you create /etc/socks/tsocks.conf from one of the examples in that directory"
	einfo "The following executables have been renamed:"
	einfo "    /usr/bin/saveme renamed to tsocks-saveme"
	einfo "    /usr/bin/validateconf renamed to tsocks-validateconf"
}
