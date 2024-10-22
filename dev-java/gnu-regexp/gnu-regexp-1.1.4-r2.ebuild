# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-regexp/gnu-regexp-1.1.4-r2.ebuild,v 1.8 2008/01/16 20:16:28 armin76 Exp $

inherit java-pkg-2 eutils

MY_P=gnu.regexp-${PV}
DESCRIPTION="GNU regular expression package for Java"
HOMEPAGE="http://www.cacas.org/java/gnu/regexp/"
SRC_URI="ftp://ftp.tralfamadore.com/pub/java/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="amd64 ~ia64 ppc ~ppc64 x86 ~x86-fbsd"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.4
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm lib/*.jar
	rm -rf docs/api
}

src_compile() {
	cd "${S}/src"
	emake -j1 JAVAC="${JAVAC}" JAVAFLAGS="${JAVACFLAGS}" || die "emake failed"
	use doc && emake javadocs
}

src_install() {
	java-pkg_newjar lib/gnu-regexp-${PV}.jar ${PN}.jar
	dodoc README TODO
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/gnu
}
