# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/log4py/log4py-1.3.ebuild,v 1.9 2007/07/04 20:18:21 hawking Exp $

inherit distutils

DESCRIPTION="A python logging module similar to log4j"
HOMEPAGE="http://www.its4you.at/english/log4py.html"
SRC_URI="http://www.its4you.at/downloads/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="ia64 ppc sparc x86"
IUSE=""

DEPEND="virtual/python"
RDEPEND=""

src_install() {
	DOCS="doc/*.* database/* log4py-test.py"
	distutils_src_install
	dohtml -r doc/html/*

	insinto /etc
	doins log4py.conf
}
