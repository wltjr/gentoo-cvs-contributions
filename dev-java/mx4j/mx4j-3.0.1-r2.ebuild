# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mx4j/mx4j-3.0.1-r2.ebuild,v 1.7 2007/11/13 21:51:55 betelgeuse Exp $

JAVA_PKG_OPT_USE="examples"
JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-opt-2 java-ant-2

DESCRIPTION="Metapackage for mx4j"
HOMEPAGE="http://mx4j.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz
	doc? ( mirror://sourceforge/${PN}/${P}.tar.gz )"

LICENSE="GPL-2"
SLOT="3.0"

KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEP="
	examples? (
		dev-java/bcel
		dev-java/log4j
		dev-java/commons-logging
		=www-servers/axis-1*
		~dev-java/servletapi-2.3
		=dev-java/burlap-3.0*
		=dev-java/hessian-3.0.8*
		dev-java/jython
		=dev-java/gnu-jaf-1*
		=dev-java/gnu-javamail-1*
	)
	=dev-java/mx4j-core-3.0*
	=dev-java/mx4j-tools-3.0*
	"

RDEPEND="
	${COMMON_DEP}
	examples? ( >=virtual/jre-1.4 )"

# We always depend on a jdk to get the package.env created
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

src_unpack() {
	unpack "${P}-src.tar.gz"

	if use doc; then
		mkdir binary && cd binary
		unpack "${P}.tar.gz"
	fi

	if use examples; then
		cd "${S}/lib"
		java-pkg_jar-from bcel bcel.jar
		java-pkg_jar-from log4j
		java-pkg_jar-from commons-logging commons-logging.jar
		java-pkg_jar-from axis-1
		java-pkg_jar-from servletapi-2.3 servlet.jar
		java-pkg_jar-from burlap-3.0
		java-pkg_jar-from hessian-3.0.8
		java-pkg_jar-from jython jython.jar
		java-pkg_jar-from gnu-jaf-1 activation.jar
		java-pkg_jar-from gnu-javamail-1 gnumail.jar mail.jar
	fi
}

src_compile() {
	cd build
	use examples && eant compile.examples
}

src_install() {
	dodoc README.txt RELEASE-NOTES-* || die

	if use examples ; then
		java-pkg_dojar dist/examples/mx4j-examples.jar
		dodir /usr/share/doc/${PF}/examples
		cp -r src/examples/mx4j/examples/* "${D}usr/share/doc/${PF}/examples"
	fi

	use source && java-pkg_dosrc src/examples/mx4j

	if use doc; then
		local docdir="${WORKDIR}/binary/${P}/docs/"
		java-pkg_dojavadoc "${docdir}/api"
		java-pkg_dohtml -r "${docdir}/images"
		java-pkg_dohtml "${docdir}"/{*.html,*.css}
	fi

	# Recording jars to get the same behaviour as before
	local jars="$(java-pkg_getjars mx4j-core-3.0,mx4j-tools-3.0)"
	for jar in ${jars//:/ }; do
		java-pkg_regjar "${jar}"
	done
}

pkg_postinst() {
	elog "Although this package can be used directly with java-config,"
	elog "ebuild developers should use mx4j-core and mx4j-tools directly."
}
