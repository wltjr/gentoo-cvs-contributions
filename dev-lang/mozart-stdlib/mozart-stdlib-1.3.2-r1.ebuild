# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mozart-stdlib/mozart-stdlib-1.3.2-r1.ebuild,v 1.2 2008/02/23 06:56:47 keri Exp $

inherit eutils

MY_P="mozart-${PV}.20060615-std"

DESCRIPTION="The Mozart Standard Library"
HOMEPAGE="http://www.mozart-oz.org/"
SRC_URI="http://www.mozart-oz.org/download/mozart-ftp/store/1.3.2-2006-06-15-tar/mozart-1.3.2.20060615-std.tar.gz"
LICENSE="Mozart"

SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"
IUSE="doc"

DEPEND="dev-lang/mozart"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PF}-ozmake.patch
	epatch "${FILESDIR}"/${P}-doc.patch
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake \
		PREFIX="${D}"/usr/lib/mozart \
		install || die "emake install failed"

	dosym /usr/lib/mozart/bin/ozmake /usr/bin/ozmake

	if use doc ; then
		dohtml -r *
	fi

	doman ozmake/ozmake.1
	dodoc ozmake/{CHANGES,DESIGN,NOTES,README}
}
