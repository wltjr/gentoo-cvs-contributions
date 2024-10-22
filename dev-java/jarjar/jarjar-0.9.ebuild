# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jarjar/jarjar-0.9.ebuild,v 1.12 2008/01/16 20:17:04 armin76 Exp $

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Tool for repackaging third-party jars."
SRC_URI="mirror://sourceforge/jarjar/${PN}-src-${PV}.zip"
HOMEPAGE="http://jarjar.sourceforge.net"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ~ia64 ppc ~ppc64 x86"
IUSE=""
COMMON_DEP="
	=dev-java/asm-2.0*
	=dev-java/gnu-regexp-1*
	>=dev-java/ant-core-1.7.0
	dev-java/java-getopt"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v src/main/com/tonicsystems/jarjar/JarJarMojo.java || die
	rm -vr src/main/gnu || die
	epatch "${FILESDIR}/0.9-system-jars.patch"
	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jar-from asm-2
	java-pkg_jar-from gnu-regexp-1
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from java-getopt-1
}

ANT_TASKS="none"
EANT_BUILD_TARGET="jar-nojarjar"

src_test() {
	# regenerates this
	cp dist/${P}.jar -i "${T}" || die
	cd lib || die
	java-pkg_jar-from junit
	cd ..
	ANT_TASKS="ant-junit" eant test
	cp "${T}/${P}.jar" dist || die
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_register-ant-task
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/*
}
