# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygments/pygments-0.10.ebuild,v 1.4 2008/07/22 04:31:35 pythonhead Exp $

NEED_PYTHON=2.3

inherit distutils

MY_PN="Pygments"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pygments is a syntax highlighting package written in Python."
HOMEPAGE="http://pygments.org/"
SRC_URI="http://cheeseshop.python.org/packages/source/P/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="doc test"

DEPEND="test? ( media-fonts/ttf-bitstream-vera )"
RDEPEND="dev-python/setuptools"

S="${WORKDIR}/${MY_P}"
DOCS="CHANGES"

src_unpack() {
	distutils_src_unpack

	# Make lexer recognize ebuilds as bash input
	sed -i \
			-e "/\(BashLexer\|aliases\)/s/\('sh'\)/\1, 'ebuild', 'eclass'/" \
			-e "/\(BashLexer\|filenames\)/s/\('\*\.sh'\)/\1, '*.ebuild', '*.eclass'/" \
				${PN}/lexers/_mapping.py ${PN}/lexers/other.py ||\
		die "sed failed."

	#Our usual PYTHONPATH manipulation trick doesn't work, it will try to run
	#tests on the installed version:
	if use test ; then
		sed -i \
		-e "s/import pygments/sys.path.insert(0, '.');import pygments/" \
		tests/run.py || \
		die "sed failed"
	fi
}

src_install(){
	distutils_src_install
	use doc && dohtml -r docs/build/
}

src_test() {
	"${python}" tests/run.py || die "tests failed"
}
