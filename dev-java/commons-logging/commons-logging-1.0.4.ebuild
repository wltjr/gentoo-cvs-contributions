# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-logging/commons-logging-1.0.4.ebuild,v 1.12 2005/01/01 18:18:31 eradicator Exp $

inherit java-pkg

DESCRIPTION="The Jakarta-Commons Logging package is an ultra-thin bridge between different logging libraries."
HOMEPAGE="http://jakarta.apache.org/commons/logging/"
SRC_URI="mirror://apache/jakarta/commons/logging/source/${PN}-${PV}-src.tar.gz"
DEPEND=">=dev-java/log4j-1.2.5
	dev-java/avalon-logkit-bin
	>=dev-java/ant-core-1.4
	jikes? ( >=dev-java/jikes-1.21 )
	junit? ( >=dev-java/junit-3.7 >=virtual/jdk-1.4 )
	!junit? ( >=virtual/jdk-1.3 )"
RDEPEND=">=virtual/jdk-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 ~ppc64"
IUSE="doc jikes junit"

S="${WORKDIR}/${P}-src/"

src_unpack() {
	unpack ${A}
	cd ${S}
	echo "log4j.jar=$(java-config -p log4j)" > build.properties
	echo "logkit.jar=$(java-config -p avalon-logkit-bin)" >> build.properties

	if use junit; then
		echo "junit.jar=$(java-config -p junit)" >> build.properties
	fi
}

src_compile() {
	local antflags="compile"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	use junit && antflags="${antflags} test"
	ant ${antflags} || die "compile problem"
}

src_install() {
	java-pkg_dojar target/${PN}-api.jar target/${PN}.jar

	dodoc RELEASE-NOTES.txt
	dohtml PROPOSAL.html STATUS.html usersguide.html
	use doc && java-pkg_dohtml -r dist/docs/
}
