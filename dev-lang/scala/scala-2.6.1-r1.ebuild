# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/scala/scala-2.6.1-r1.ebuild,v 1.1 2008/02/09 16:13:45 betelgeuse Exp $

JAVA_PKG_IUSE="doc examples source"
WANT_ANT_TASKS="ant-nodeps"
inherit eutils check-reqs java-pkg-2 java-ant-2 versionator

MY_P="${P}-final"

# creating the binary:
# JAVA_PKG_FORCE_VM="$available-1.4" USE="doc examples source" ebuild scala-*.ebuild compile
# cd $WORDKIR
# tar -cjf $DISTDIR/scala-$PN-gentoo-binary.tar.bz2 dists docs/TODO

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="http://www.scala-lang.org/"
SRC_URI="!binary? ( http://www.scala-lang.org/downloads/distrib/files/${MY_P}-sources.tgz )
	binary? ( mirror://gentoo/${P}-gentoo-binary.tar.bz2 )"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="binary"
# one fails with 1.7, two with 1.4 (blackdown)
RESTRICT="test"

DEPEND=">=virtual/jdk-1.4
	!binary? (
		dev-java/ant-contrib
		dev-java/jline
	)"
RDEPEND=">=virtual/jre-1.4
	dev-java/jline"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	java-pkg-2_pkg_setup

	if ! use binary; then
		debug-print "Checking for sufficient physical RAM"

		ewarn "This package can fail to build with memory allocation errors in some cases."
		ewarn "If you are unable to build from sources, please try USE=binary"
		ewarn "for this package. See bug #181390 for more information."
		ebeep 3
		epause 5

		if use amd64; then
			CHECKREQS_MEMORY="1024"
		else
			CHECKREQS_MEMORY="512"
		fi
		check_reqs
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if ! use binary; then
		# remove check for ant-nodeps.jar in ant-core/lib; make docs opt-in;
		# don't increase version; don't create dist archives
		epatch "${FILESDIR}/${P}-build.xml.patch"

		cd lib || die
		# other jars are needed for bootstrap
		rm -v ant-contrib.jar jline.jar #cldcapi10.jar midpapi10.jar msil.jar *.dll || die
		java-pkg_jar-from --build-only ant-contrib
		java-pkg_jar-from jline
	fi
}

src_compile() {
	if ! use binary; then
		if use amd64; then
			export ANT_OPTS="-Xmx1024M -Xms1024M"
		else
			export ANT_OPTS="-Xmx512M -Xms512M -Xss1024k"
		fi
		local target
		if [[ "$(get_version_component_range 3)"  == "0" ]];
		then
			target="minor"
		else
			target="patch"
		fi
		eant dist.${target} $(use_doc -Ddo.docs=true)
	else
		einfo "Skipping compilation, USE=binary is set."
	fi
}

src_test() {
	bash test/scalatest || die "Some tests aren't passed"
}

scala_launcher() {
	local SCALADIR="/usr/share/${PN}"
	local bcp="${SCALADIR}/lib/scala-library.jar"
	java-pkg_dolauncher "${1}" --main "${2}" ${3} \
		--java_args "-Xmx256M -Xms16M -Xbootclasspath/a:${bcp} -Dscala.home=\\\"${SCALADIR}\\\" -Denv.classpath=\\\"\${CLASSPATH}\\\""
}

src_install() {
	cd dists/${MY_P} || die
	local SCALADIR="/usr/share/${PN}/"

	# sources are .scala so no use for java-pkg_dosrc
	if use source; then
		dodir "${SCALADIR}/src"
		insinto "${SCALADIR}/src"
		doins lib/*-src.jar
	fi

	rm lib/*-src.jar || die
	java-pkg_dojar lib/*.jar
	use binary && java-pkg_register-dependency jline

	doman man/man1/*.1 || die
	local docdir="doc/${PN}"
	dodoc "${docdir}/README" ../../docs/TODO || die
	if use doc; then
		java-pkg_dojavadoc "${docdir}/api"
		dohtml -r "${docdir}/tools" || die
	fi

	use examples && java-pkg_doexamples "${docdir}/examples"

	scala_launcher fsc scala.tools.nsc.CompileClient
	scala_launcher scala scala.tools.nsc.MainGenericRunner
	scala_launcher scalac scala.tools.nsc.Main
	scala_launcher scaladoc scala.tools.nsc.Main "--pkg_args -doc"
}
