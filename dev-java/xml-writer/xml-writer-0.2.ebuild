# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xml-writer/xml-writer-0.2.ebuild,v 1.3 2007/10/06 20:19:55 dertobi123 Exp $

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A simple XML Writer"
HOMEPAGE="http://www.megginson.com/downloads/"
SRC_URI="http://www.megginson.com/downloads/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip
		${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_xml-rewrite -f build.xml -e javac -d -a filtering
	rm -v *.jar || die
	rm -v *.class || die
	rm -rv classes || die
}

src_install() {
	java-pkg_dojar *.jar
	dodoc README ChangeLog BUGS || die
	use doc && java-pkg_dojavadoc docs/javadoc
	use examples && java-pkg_doexamples *.java sample.xml
	use source && java-pkg_dosrc src/*
}
