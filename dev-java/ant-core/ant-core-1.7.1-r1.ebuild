# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-core/ant-core-1.7.1-r1.ebuild,v 1.2 2008/07/16 21:25:23 caster Exp $

# don't depend on itself
JAVA_ANT_DISABLE_ANT_CORE_DEP=true
# rewriting build.xml files for the testcases has no reason atm
JAVA_PKG_BSFIX_ALL=no
JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

MY_P="apache-ant-${PV}"

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files."
HOMEPAGE="http://ant.apache.org/"
SRC_URI="mirror://apache/ant/source/${MY_P}-src.tar.bz2
	mirror://gentoo/ant-${PV}-gentoo.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	!dev-java/ant-tasks
	!dev-java/ant-optional"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# remove bundled xerces
	rm -v lib/*.jar || die

	# use our split-ant build.xml
	mv -f "${WORKDIR}/build.xml" . || die

	# bug #196080
	java-ant_bsfix_one build.xml
}

src_compile() {
	export ANT_HOME=""

	local bsyscp

	# this ensures that when building ant with bootstrapped ant,
	# only the source is used for resolving references, and not
	# the classes in bootstrapped ant
	# but jikes in kaffe has issues with this...
	if ! java-pkg_current-vm-matches kaffe; then
		bsyscp="-Dbuild.sysclasspath=ignore"
	fi

	./build.sh ${bsyscp} jars-core internal_dist $(use_doc javadocs) \
		|| die "build failed"
}

src_install() {
	dodir /usr/share/ant/lib
	for jar in ant.jar ant-bootstrap.jar ant-launcher.jar ; do
		java-pkg_dojar build/lib/${jar}
		dosym /usr/share/${PN}/lib/${jar} /usr/share/ant/lib/${jar}
	done

	newbin "${FILESDIR}/${PV}-ant" ant || die "failed to install wrapper"
	dodir /usr/share/${PN}/bin
	for each in antRun runant.pl runant.py complete-ant-cmd.pl ; do
		dobin "${S}/src/script/${each}"
		dosym /usr/bin/${each} /usr/share/${PN}/bin/${each}
	done
	dosym /usr/share/${PN}/bin /usr/share/ant/bin

	insinto /usr/share/${PN}
	doins -r dist/etc
	dosym /usr/share/${PN}/etc /usr/share/ant/etc

	echo "ANT_HOME=\"/usr/share/ant\"" > "${T}/20ant"
	doenvd "${T}/20ant" || die "failed to install env.d file"

	dodoc README WHATSNEW KEYS

	if use doc; then
		dohtml welcome.html
		dohtml -r docs/*
		java-pkg_dojavadoc --symlink manual/api build/javadocs
	fi

	use source && java-pkg_dosrc src/main/*
}

pkg_postinst() {
	elog "The way of packaging ant in Gentoo has changed significantly since"
	elog "the 1.7.0 version, For more information, please see:"
	elog "http://www.gentoo.org/proj/en/java/ant-guide.xml"
	elog
	elog "Since 1.7.1, the ant-tasks meta-ebuild has been removed and its USE"
	elog "flags have been moved to dev-java/ant."
}
