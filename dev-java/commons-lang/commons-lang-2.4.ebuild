# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-lang/commons-lang-2.4.ebuild,v 1.1 2008/06/29 21:55:58 betelgeuse Exp $

EAPI=1
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="http://commons.apache.org/lang/"
SRC_URI="mirror://apache/commons/lang/source/${P}-src.tar.gz"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit:0 )"
RDEPEND=">=virtual/jre-1.4"

LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

S="${WORKDIR}/${P}-src"

JAVA_ANT_ENCODING="ISO-8859-1"

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar

	dodoc RELEASE-NOTES.txt NOTICE.txt || die
	dohtml *.html || die
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
