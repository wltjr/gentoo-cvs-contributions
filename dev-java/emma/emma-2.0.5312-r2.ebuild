# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/emma/emma-2.0.5312-r2.ebuild,v 1.5 2008/07/18 07:41:26 opfer Exp $

# No support for javadocs in build.xml
EAPI=1
JAVA_PKG_IUSE="source"

inherit base java-pkg-2 java-ant-2

DESCRIPTION="a free Java code coverage tool"
HOMEPAGE="http://emma.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ppc ~ppc64 x86 ~x86-fbsd"

IUSE="+launcher"

RDEPEND=">=virtual/jre-1.4
	>=dev-java/ant-core-1.7.0
	launcher? ( !sci-biology/emboss )"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

PATCHES=( "${FILESDIR}/${P}-java15api.patch" )

EANT_BUILD_TARGET="build"

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dojar dist/${PN}_ant.jar
	java-pkg_register-ant-task
	use launcher && java-pkg_dolauncher ${PN} --main emmarun
	# One of these does not have java sources
	use source && java-pkg_dosrc */*/com 2> /dev/null
}
