# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/epsilon/epsilon-0.5.9.ebuild,v 1.1 2008/04/04 05:14:42 lordvan Exp $

inherit distutils

DESCRIPTION="Epsilon is a Python utilities package, most famous for its Time class."
HOMEPAGE="http://divmod.org/trac/wiki/DivmodEpsilon"
SRC_URI="mirror://gentoo/Epsilon-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~ia64 ~ppc64 ~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	>=dev-python/twisted-2.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Epsilon-${PV}"

DOCS="NAME.txt NEWS.txt"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Rename to avoid file-collisions
	mv bin/benchmark bin/epsilon-benchmark
	sed -i \
		-e "s#bin/benchmark#bin/epsilon-benchmark#" \
		setup.py || die "sed failed"
}

src_compile() {
	# skip this, or epsilon will install the temporary "build" dir
	true
}

src_test() {
	# release tests needs DivmodCombinator
	rm epsilon/test/test_release.py*
	PYTHONPATH=. trial epsilon || die "tests failed"
}
