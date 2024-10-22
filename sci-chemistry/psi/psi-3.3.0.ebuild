# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/psi/psi-3.3.0.ebuild,v 1.2 2008/07/08 16:26:10 mr_bones_ Exp $

inherit autotools eutils

DESCRIPTION="Suite of ab initio quantum chemistry programs to compute various molecular properties"
HOMEPAGE="http://www.psicode.org/"
SRC_URI="mirror://sourceforge/psicode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/blas
	virtual/lapack
	>=sci-libs/libint-1.1.4"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

S="${WORKDIR}/${PN}${PV:0:1}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/dont-build-libint.patch
	epatch "${FILESDIR}"/use-external-libint.patch
	epatch "${FILESDIR}"/${PV}-gcc-4.3.patch
	eautoreconf
}

src_compile() {
	# This variable gets set sometimes to /usr/lib/src and breaks stuff
	unset CLIBS

	econf \
		--with-opt="${CFLAGS}" \
		--datadir=/usr/share/${PN} \
		|| die "configure failed"
	emake \
		SCRATCH="${WORKDIR}/libint" \
		|| die "make failed"
}

src_test() {
	emake tests || die
}

src_install() {
	einstall \
		datadir=${D}/usr/share/${PN} \
		docdir=${D}/usr/share/doc/${PF} \
		|| die "install failed"
}
