# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sax/sax-2.2.1-r2.ebuild,v 1.6 2007/08/14 07:54:11 opfer Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="SAX is the Simple API for XML, originally a Java-only API. SAX was the first widely adopted API for XML in Java."

HOMEPAGE="http://sax.sourceforge.net/"
SRC_URI="mirror://sourceforge/sax/sax2r3.zip"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/sax2r3"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rf classes *.jar
}

src_install() {
	java-pkg_newjar sax2.jar
	dodoc ChangeLog CHANGES README || die

	use doc && java-pkg_dojavadoc docs/javadoc
	use source && java-pkg_dosrc ${S}/src/*
}
