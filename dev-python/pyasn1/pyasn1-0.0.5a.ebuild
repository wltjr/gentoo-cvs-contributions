# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyasn1/pyasn1-0.0.5a.ebuild,v 1.2 2006/12/30 18:19:18 dev-zero Exp $

inherit distutils

KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"

DESCRIPTION="ASN.1 types and codecs (BER, CER, DER) implementation."
HOMEPAGE="http://pyasn1.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="CHANGES"

src_install() {
	distutils_src_install
	dohtml doc/*
	insinto /usr/share/doc/${PF}
	doins -r examples
}

src_test() {
	export PYTHONPATH="${PYTHONPATH}:${S}/build/lib"
	python test/suite.py || die "tests failed"
}
