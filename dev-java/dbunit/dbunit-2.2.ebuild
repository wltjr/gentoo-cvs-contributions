# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dbunit/dbunit-2.2.ebuild,v 1.7 2008/01/10 22:22:20 caster Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="DBUnit is a JUnit extension targeted for database-driven projects."
HOMEPAGE="http://www.dbunit.org"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"
IUSE=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=virtual/jre-1.4
	>=dev-java/poi-2.0
	=dev-java/junit-3.8*
	>=dev-java/ant-core-1.6
	dev-java/commons-logging
	>=dev-java/commons-lang-2.1
	dev-java/commons-collections"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp ${FILESDIR}/build.xml build.xml

	cd ${S}/lib || die
	#rm -v *.jar
	java-pkg_jar-from poi
	java-pkg_jar-from junit
	java-pkg_jar-from ant-core
	java-pkg_jar-from commons-logging
	java-pkg_jar-from commons-lang-2.1
	java-pkg_jar-from commons-collections
}

EANT_DOC_TARGET="docs"

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc todo.txt || die
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/java/org
}
