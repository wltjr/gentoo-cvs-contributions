# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fastutil/fastutil-5.1.2.ebuild,v 1.2 2008/04/07 11:56:55 corsair Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Provides faster type-specific maps, sets and lists with a small memory footprint."
SRC_URI="http://fastutil.dsi.unimi.it/${P}-src.tar.gz"
HOMEPAGE="http://fastutil.dsi.unimi.it"
LICENSE="LGPL-2.1"
SLOT="5.0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

src_compile() {
	emake sources || die "failed to make sources"
	# bug 162650 and #175578
	java-pkg_init-compiler_
	[[ ${GENTOO_COMPILER} != "javac" ]] && export ANT_OPTS="-Xmx512m"
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_newjar ${P}.jar

	dodoc CHANGES README || die

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc java/it
}
