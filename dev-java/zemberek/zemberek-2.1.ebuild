# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/zemberek/zemberek-2.1.ebuild,v 1.3 2008/07/26 07:45:25 corsair Exp $

EAPI=1
JAVA_PKG_IUSE="source doc test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Zemberek NLP library"
HOMEPAGE="http://code.google.com/p/zemberek/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-nolibs-src.zip"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
LANGS="tr tk"

S=${WORKDIR}/${P}-nolibs-src

IUSE="linguas_tk +linguas_tr"

RDEPEND=">=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	test?
	(
		dev-java/junit:4
		dev-java/ant-junit4
	)
	app-arch/unzip"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	mkdir -p lib/{dagitim,gelistirme} || die
	epatch "${FILESDIR}"/${P}-287-kitabevi.patch
	use test && java-pkg_jarfrom --build-only --into lib/gelistirme junit-4 junit.jar
}

src_compile() {
	strip-linguas ${LANGS}
	local anttargs
	for jar in cekirdek demo ${LINGUAS}; do
		anttargs="${anttargs} jar-${jar}"
	done
	eant ${anttargs} $(use_doc javadocs)
}

src_install() {
	strip-linguas ${LANGS}
	local sourcetrees=""
	for jar in cekirdek demo ${LINGUAS}; do
		java-pkg_newjar dagitim/jar/zemberek-${jar}-${PV}.jar zemberek2-${jar}.jar
		sourcetrees="${sourcetrees} src/${jar}/net"
	done
	use source && java-pkg_dosrc ${sourcetrees}
	use doc && java-pkg_dojavadoc build/java-docs/api
	java-pkg_dolauncher zemberek-demo --main net.zemberek.demo.DemoMain
	dodoc dokuman/lisanslar/* || die
	dodoc surumler.txt || die
}

src_test() {
	ANT_TASKS="ant-junit4" eant unit-test
}
