# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/libapreq2/libapreq2-2.08-r2.ebuild,v 1.9 2008/03/22 17:02:13 maekke Exp $

inherit apache-module perl-module multilib

DESCRIPTION="A library for manipulating client request data via the Apache API"
SRC_URI="mirror://apache/apreq/${P}.tar.gz"
HOMEPAGE="http://httpd.apache.org/apreq/"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="perl"

DEPEND="${DEPEND}
	perl? (
		>=dev-perl/ExtUtils-XSBuilder-0.23
		dev-perl/version
		>=www-apache/mod_perl-2
	)"
RDEPEND="${DEPEND}"

APACHE2_MOD_FILE="module/apache2/.libs/mod_apreq2.so"
APACHE2_MOD_CONF="76_mod_apreq"
APACHE2_MOD_DEFINE="APREQ"
DOCFILES="docs/html/*.html CHANGES README INSTALL MANIFEST"

need_apache2

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/libapreq2-2.08-doc.patch

	sed -i -e "s/PERL \$PERL_OPTS/PERL/" "${S}"/acinclude.m4
	sed -i -e "s/PERL \$PERL_OPTS/PERL/" "${S}"/aclocal.m4
	sed -i -e "s/PERL \$PERL_OPTS/PERL/" "${S}"/configure
}

src_compile() {
	econf \
		--with-apache2-apxs=${APXS} \
		$(use_enable perl perl-glue) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	apache-module_src_install

	make DESTDIR="${D}" install || die "make install failed"
	doman docs/man/man3/*.3

	fixlocalpod

	for i in $(find "${D}" -type f -not -name '*.so'); do
		if file ${i} | grep -i " text"; then
			sed -i -e "s:${D}:/:g" ${i}
		fi
	done
}
