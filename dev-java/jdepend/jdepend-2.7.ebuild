# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdepend/jdepend-2.7.ebuild,v 1.1 2004/07/17 14:05:47 axxo Exp $

inherit java-pkg

DESCRIPTION="JDepend traverses Java class file directories and generates design quality metrics for each Java package."
HOMEPAGE="http://www.clarkware.com/software/JDepend.html"
SRC_URI="http://www.clarkware.com/software/${PN}-${PV}.zip"

LICENSE="jdepend"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc jikes"

DEPEND=">=virtual/jdk-1.3
		>=app-arch/unzip-5.50-r1
		>=dev-java/ant-1.4
		jikes? ( >=dev-java/jikes-1.17 )"
RDEPEND=">=virtual/jdk-1.3"

#TODO Do junit testing but resolve the circular dependency we have with ant.
src_compile() {
	local myc

	if use jikes ; then
		myc="${myc} -Dbuild.compiler=jikes"
	fi

#	use junit && export CLASSPATH=$CLASSPATH:`java-config --classpath=junit`

	ant ${myc} jar || die "Failed Compiling"

#	if use junit ; then
#		ant test || die "Failed Testing Packages Integrity"
#	fi
}

src_install() {
	java-pkg_dojar lib/jdepend.jar || die "Failed Installing"
	dodoc LICENSE README

	dodir /usr/share/ant/lib
	dosym /usr/share/jdepend/lib/jdepend.jar /usr/share/ant/lib

	if use doc; then
		dohtml docs/JDepend.html
		cp -r docs/api ${D}/usr/share/doc/${PN}-${PV}/html
		cp -r docs/images ${D}/usr/share/doc/${PN}-${PV}/html
	fi
}
