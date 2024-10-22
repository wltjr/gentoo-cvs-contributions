# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libetpan/libetpan-0.54.ebuild,v 1.8 2008/05/13 11:45:44 armin76 Exp $

DESCRIPTION="A portable, efficient middleware for different kinds of mail access."
HOMEPAGE="http://libetpan.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="berkdb debug gnutls ipv6 liblockfile sasl ssl"

DEPEND="virtual/libc
	berkdb? ( sys-libs/db )
	gnutls? ( net-libs/gnutls )
	!gnutls? ( ssl? ( dev-libs/openssl ) )
	sasl? ( dev-libs/cyrus-sasl )
	liblockfile? ( net-libs/liblockfile )"

src_compile() {
	local sslconf

	if use ssl; then
		if use gnutls; then
			sslconf="--with-gnutls --without-openssl"
		else
			sslconf="--without-gnutls --with-openssl"
		fi
	else
		if use gnutls; then
			sslconf="--with-gnutls --without-openssl"
		else
			sslconf="--without-gnutls --without-openssl"
		fi
	fi

	econf \
		$(use_enable debug) \
		$(use_enable berkdb db) \
		$(use_with sasl) \
		$(use_enable ipv6) \
		$(use_enable liblockfile lockfile) \
		${sslconf} \
		|| die "econf failed"

	# build system is broken, we need -j1 (bug #126848) - Ticho, 2006-05-02
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc NEWS ChangeLog
}

pkg_postinst() {
	echo
	ewarn "The soname for libetpan has changed after libetpan-0.53."
	ewarn "If you have upgraded from that or earlier version, it is recommended to run"
	ewarn "revdep-rebuild to fix any linking errors caused by this change."
	echo
}
