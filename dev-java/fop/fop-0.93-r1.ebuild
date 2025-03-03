# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fop/fop-0.93-r1.ebuild,v 1.8 2007/09/18 22:18:32 betelgeuse Exp $

# TODO: if 'doc' use flag is used then should build also extra docs ('docs' ant target), currently it cannot
#       be built as it needs forrest which we do not have
# TODO: package and use optional dependency jeuclid

JAVA_PKG_IUSE="doc examples source"
WANT_ANT_TASKS="ant-trax"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Formatting Objects Processor is a print formatter driven by XSL"
HOMEPAGE="http://xmlgraphics.apache.org/fop/"
SRC_URI="mirror://apache/xmlgraphics/${PN}/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
# doesn't work with java.awt.headless
RESTRICT="test"
KEYWORDS="amd64 ~ia64 ppc ~ppc64 x86"
IUSE="hyphenation jai jimi"

COMMON_DEPEND="
	>=dev-java/avalon-framework-4.2
	>=dev-java/batik-1.6
	dev-java/commons-io
	dev-java/commons-logging
	=dev-java/servletapi-2.2*
	>=dev-java/xmlgraphics-commons-1.1
	jai? ( dev-java/sun-jai-bin )
	jimi? ( dev-java/sun-jimi )"

RDEPEND=">=virtual/jre-1.4
	dev-java/ant-core
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
	=dev-java/eclipse-ecj-3.2*
	hyphenation? ( dev-java/offo-hyphenation )
	${COMMON_DEPEND}"
#	test? (
#		=dev-java/junit-3.8*
#		dev-java/xmlunit
#	)"

pkg_setup() {
	if ! built_with_use dev-java/xmlgraphics-commons jpeg; then
		msg="${CATEGORY}/${P} needs dev-java/xmlgraphics-commons built with"
		msg="${msg} the jpeg use flag"
		eerror ${msg}
		die "Recompile dev-java/xmlgraphics-commons with the jpeg use flag"
	fi
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# automagic is bad
	java-ant_ignore-system-classes || die

	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom ant-core ant.jar
	java-pkg_jarfrom avalon-framework-4.2 avalon-framework.jar \
		avalon-framework-4.2.0.jar
	java-pkg_jarfrom batik-1.6 batik-all.jar batik-all-1.6.jar
	java-pkg_jarfrom commons-io-1 commons-io.jar commons-io-1.1.jar
	java-pkg_jarfrom commons-logging commons-logging.jar \
		commons-logging-1.0.4.jar
	java-pkg_jarfrom servletapi-2.2 servlet.jar servlet-2.2.jar
	java-pkg_jarfrom xmlgraphics-commons-1 xmlgraphics-commons.jar \
		xmlgraphics-commons-1.1.jar

	use jai && java-pkg_jar-from sun-jai-bin
	use jimi && java-pkg_jar-from sun-jimi
}

src_compile() {
	# because I killed the automagic tests; all our JDK's have JCE
	local af="-Djdk14.present=true -Djce.present=true"
	use hyphenation && af="${af} -Duser.hyph.dir=/usr/share/offo-hyphenation/hyph/"
	use jai && af="${af} -Djai.present=true"
	use jimi && af="${af} -Djimi.present=true"

	export ANT_OPTS="-Xmx256M"
	java-pkg_force-compiler ecj-3.2
	eant ${af} package $(use_doc javadocs)
}

src_test() {
	if use test ; then
		cd "${S}/lib"
		java-pkg_jar-from xmlunit-1
		java-pkg_jar-from junit
		cd "${S}"
	fi

	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant -Djunit.fork=off junit
}

src_install() {
	java-pkg_dojar build/fop.jar build/fop-sandbox.jar
	use hyphenation && java-pkg_dojar build/fop-hyph.jar

	# doesn't support everything upstream launcher does...
	java-pkg_dolauncher ${PN} --main org.apache.fop.cli.Main

	dodoc NOTICE README

	use doc && java-pkg_dojavadoc build/javadocs
	use examples && java-pkg_doexamples examples/* conf
	use source && java-pkg_dosrc src/java/org src/java-1.4/* src/sandbox/org
}
