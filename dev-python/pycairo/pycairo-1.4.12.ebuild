# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycairo/pycairo-1.4.12.ebuild,v 1.7 2008/07/21 17:22:44 nixnut Exp $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="Python wrapper for cairo vector graphics library"
HOMEPAGE="http://cairographics.org/pycairo/"
SRC_URI="http://cairographics.org/releases/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=x11-libs/cairo-1.4.12"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

PYTHON_MODNAME="cairo"
DOCS="AUTHORS doc/*"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# don't run py-compile
	sed -i \
		-e '/if test -n "$$dlist"; then/,/else :; fi/d' \
		cairo/Makefile.in || die "sed in cairo/Makefile.in failed"
}

src_install() {
	distutils_src_install

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
		rm "${D}"/usr/share/doc/${PF}/examples/Makefile*
	fi
}

src_test() {
	cd test
	PYTHONPATH="$(ls -d ${S}/build/lib.*)" "${python}" test.py || die "tests failed"
}
