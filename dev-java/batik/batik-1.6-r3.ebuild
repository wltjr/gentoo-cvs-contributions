# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/batik/batik-1.6-r3.ebuild,v 1.8 2008/01/20 22:27:27 caster Exp $

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java based SVG toolkit"
HOMEPAGE="http://xml.apache.org/batik/"
SRC_URI="mirror://apache/xml/batik/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="1.6"
KEYWORDS="amd64 ~ia64 ppc ~ppc64 x86"
IUSE="doc python tcl"

CDEPEND="=dev-java/rhino-1.5*
	>=dev-java/xerces-2.7.1
	=dev-java/xml-commons-external-1.3*
	python? ( dev-java/jython )
	tcl? ( dev-java/jacl )"
DEPEND="=virtual/jdk-1.4*
	dev-java/ant-core
	app-arch/unzip
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

S="${WORKDIR}/xml-${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-jikes.patch"
	epatch "${FILESDIR}/${P}-dont-copy-deps.patch"

	java-ant_ignore-system-classes

	cd lib
	rm -f *.jar build/*.jar

	java-pkg_jar-from xml-commons-external-1.3
	java-pkg_jar-from xerces-2
	# Can't make rhino optional because
	# apps/svgbrowser needs it
	java-pkg_jar-from rhino-1.5
	use python && java-pkg_jar-from jython
	use tcl && java-pkg_jar-from jacl
}

src_compile() {
	# Fails to build on amd64 without this
	if use amd64 ; then
		export ANT_OPTS="-Xmx1g"
	else
		export ANT_OPTS="-Xmx256m"
	fi

	eant jars all-jar $(use_doc)
}

src_install() {
	java-pkg_dojar ${P}/batik*.jar

	cd ${P}/lib

	# needed because batik expects this layout:
	# batik.jar lib/*.jar
	# there are hardcoded classpaths in the manifest :(
	dodir /usr/share/${PN}-${SLOT}/lib/lib/
	for jar in *.jar
	do
		java-pkg_dojar ${jar}
		dosym ../${jar} /usr/share/${PN}-${SLOT}/lib/lib/${jar}
	done

	cd "${S}"
	dodoc README || die "dodoc failed"
	use doc && java-pkg_dojavadoc ${P}/docs/javadoc

	# pwd fixes bug #116976
	java-pkg_dolauncher batik-${SLOT} --pwd "/usr/share/${PN}-${SLOT}/" \
		--main org.apache.batik.apps.svgbrowser.Main

	# To find these lsjar batik-${SLOT} | grep Main.class
	for launcher in ttf2svg slideshow svgpp rasterizer; do
		java-pkg_dolauncher batik-${launcher}-${SLOT} \
			--main org.apache.batik.apps.${launcher}.Main
	done
}
