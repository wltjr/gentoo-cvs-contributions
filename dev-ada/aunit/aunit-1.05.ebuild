# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/aunit/aunit-1.05.ebuild,v 1.2 2008/01/24 21:33:32 george Exp $

inherit gnat

IUSE=""

DESCRIPTION="Aunit, Ada unit testing framework"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="https://libre.adacore.com/aunit/"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND="virtual/ada"

lib_compile() {
	gnatmake -Paunit
	gnatmake -Paunit_dyn
}

lib_install() {
	mv aunit/lib/* ${DL}
	chmod 0444 ${DL}/*.ali
}

src_install () {
	dodir ${AdalibSpecsDir}/${PN}
	insinto ${AdalibSpecsDir}/${PN}
	doins aunit/*/*.ad?

	dodir ${AdalibDataDir}/${PN}
	insinto ${AdalibDataDir}/${PN}
	doins -r support/aunit.xml template/

	#set up environment
	echo "LDPATH=%DL%" > ${LibEnv}
	echo "ADA_OBJECTS_PATH=%DL%" >> ${LibEnv}
	echo "ADA_INCLUDE_PATH=/usr/include/ada/${PN}" >> ${LibEnv}

	gnat_src_install

	dodoc README docs/aunit.txt
	dohtml docs/aunit.{html,css}
	doinfo docs/aunit.info
	cp -dPr test/ docs/aunit.pdf "${D}/usr/share/doc/${PF}"
}
