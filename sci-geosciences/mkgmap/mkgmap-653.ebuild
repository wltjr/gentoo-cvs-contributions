# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/mkgmap/mkgmap-653.ebuild,v 1.1 2008/07/28 01:01:28 hanno Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Tool to create garmin maps"
HOMEPAGE="http://www.parabola.me.uk/mkgmap/"
SRC_URI="http://www.parabola.me.uk/mkgmap/snapshots/${PN}-r${PV}-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"
S="${WORKDIR}/${PN}-r${PV}"

src_compile() {
	JAVA_ANT_ENCODING=UTF-8
	eant dist
}

src_install() {
	java-pkg_newjar "dist/${PN}.jar" || die "java-pkg_newjar failed"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" || die "java-pkg_dolauncher failed"

	dodoc dist/README dist/doc/Credits dist/doc/*.txt || die "dodoc failed"
	doman dist/doc/mkgmap.1 || die "doman failed"
}
