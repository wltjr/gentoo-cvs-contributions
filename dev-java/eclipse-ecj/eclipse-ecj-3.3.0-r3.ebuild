# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/eclipse-ecj/eclipse-ecj-3.3.0-r3.ebuild,v 1.1 2008/07/21 22:07:25 betelgeuse Exp $

inherit eutils java-pkg-2

MY_PN="ecj"
DMF="R-${PV}-200706251500"
S="${WORKDIR}"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF/.0}/${MY_PN}src.zip"

LICENSE="EPL-1.0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
SLOT="3.3"
IUSE=""

COMMON_DEPEND="app-admin/eselect-ecj"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.4
	sys-apps/findutils
	app-arch/unzip
	${COMMON_DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# own package
	rm -f org/eclipse/jdt/core/JDTCompilerAdapter.java
	rm -fr org/eclipse/jdt/internal/antadapter

	# what the heck...?! java6
	rm -fr org/eclipse/jdt/internal/compiler/tool/ \
		org/eclipse/jdt/internal/compiler/apt/

	# gcj feature
	epatch "${FILESDIR}"/${P}-gcj.patch
}

src_compile() {
	local javac="javac" java="java" jar="jar"

	mkdir -p bootstrap
	cp -a org bootstrap

	einfo "bootstrapping ${MY_PN} with javac"

	cd "${S}"/bootstrap
	${javac} $(find org/ -name '*.java') || die "${MY_PN} bootstrap failed!"

	find org/ -name '*.class' -o -name '*.properties' -o -name '*.rsc' | \
		xargs ${jar} cf ${MY_PN}.jar

	einfo "build ${MY_PN} with bootstrapped ${MY_PN}"

	cd "${S}"
	${java} -classpath bootstrap/${MY_PN}.jar \
		org.eclipse.jdt.internal.compiler.batch.Main -encoding ISO-8859-1 org \
		|| die "${MY_PN} build failed!"
	find org/ -name '*.class' -o -name '*.properties' -o -name '*.rsc' | \
		xargs ${jar} cf ${MY_PN}.jar
}

src_install() {
	java-pkg_dojar ${MY_PN}.jar
	java-pkg_dolauncher ${MY_PN}-${SLOT} --main \
		org.eclipse.jdt.internal.compiler.batch.Main
}

pkg_postinst() {
	einfo "To get the Compiler Adapter of ECJ for ANT..."
	einfo " # emerge ant-eclipse-ecj"
	echo
	einfo "To select between slots of ECJ..."
	einfo " # eselect ecj"

	eselect ecj update ecj-${SLOT}
}

pkg_postrm() {
	eselect ecj update
}
