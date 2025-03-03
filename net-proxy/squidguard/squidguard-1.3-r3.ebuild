# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/squidguard/squidguard-1.3-r3.ebuild,v 1.1 2008/07/16 21:11:40 mrness Exp $

WANT_AUTOMAKE=none

inherit eutils autotools

DESCRIPTION="Combined filter, redirector and access controller plugin for Squid."
HOMEPAGE="http://www.squidguard.org"
SRC_URI="http://www.squidguard.org/Downloads/squidGuard-${PV}.tar.gz
	http://www.squidguard.org/Downloads/Patches/${PV}/squidGuard-${PV}-patch-20080714.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="ldap"

RDEPEND="net-proxy/squid
	>=sys-libs/db-2
	ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/squidGuard-${PV}"

RESTRICT="test" # tests are currently broken

src_unpack() {
	unpack ${A}

	cd "${S}"
	cp ../squidGuard-${PV}-patch-20080714/src/sgDb.c src/ || die "failed to replace sgDiv.c"
	cp ../squidGuard-${PV}-patch-20080714/src/sgDiv.c.in src/ || die "failed to replace sgDiv.c.in"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-autoheader.patch"
	epatch "${FILESDIR}/${P}-bison.patch"
	eautoreconf
}

src_compile() {
	econf \
		$(use_with ldap) \
		--with-sg-config=/etc/squidGuard/squidGuard.conf \
		--with-sg-logdir=/var/log/squidGuard \
		|| die "configure has failed"

	emake || die "make has failed"
}

src_install() {
	emake prefix="/usr" INSTDIR="${D}" install || die "emake install has failed"

	keepdir /var/log/squidGuard
	fowners squid:squid /var/log/squidGuard

	insinto /etc/squidGuard/sample
	doins "${FILESDIR}"/squidGuard.conf.*
	insinto /etc/squidGuard/sample/db
	doins "${FILESDIR}"/blockedsites

	dodoc ANNOUNCE CHANGELOG README
	dohtml doc/*.html
	docinto text
	dodoc doc/*.txt
}

pkg_postinst() {
	einfo "To enable squidGuard, add the following lines to /etc/squid/squid.conf:"
	einfo "    url_rewrite_program /usr/bin/squidGuard"
	einfo "    url_rewrite_children 10"
	einfo ""
	einfo "Remember to edit /etc/squidGuard/squidGuard.conf first!"
	einfo "Examples can be found in /etc/squidGuard/sample/"
}
