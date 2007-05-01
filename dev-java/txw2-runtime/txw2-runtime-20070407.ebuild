# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/txw2-runtime/txw2-runtime-20070407.ebuild,v 1.1 2007/05/01 19:24:26 nelchael Exp $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="TXW is a library that allows you to write XML documents."
HOMEPAGE="https://txw.dev.java.net/"
SRC_URI="https://txw.dev.java.net/files/documents/3310/54821/txw2-${PV}.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEP="=dev-java/codemodel-2*
	dev-java/jsr173
	dev-java/relaxng-datatype
	dev-java/rngom
	dev-java/xsom"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/txw2-${PV}"

src_unpack() {

	unpack ${A}

	cd "${S}"
	rm -v *.jar || die
	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom ant-core
	java-pkg_jarfrom codemodel-2
	java-pkg_jarfrom jsr173
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom rngom
	java-pkg_jarfrom xsom

	cd "${S}"
	unzip -qq txw2-src.zip -d runtime || die unzip failed
	unzip -qq txw2c-src.zip -d compiler || die unzip failed

	cp "${FILESDIR}/build.xml-20070407" "${S}/build.xml" -i || die cp failed

}

EANT_BUILD_TARGET="runtime-jar"

src_install() {
	java-pkg_newjar txw2.jar

	use doc && java-pkg_dojavadoc build/javadoc/*
	use source && java-pkg_dosrc runtime/*
}
