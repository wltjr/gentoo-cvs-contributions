# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/edtftpj/edtftpj-2.0.2.ebuild,v 1.4 2008/07/16 14:11:07 nixnut Exp $

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="FTP client library written in Java"
SRC_URI="http://www.enterprisedt.com/products/edtftpj/download/${P}.zip"
HOMEPAGE="http://www.enterprisedt.com"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=virtual/jre-1.4
	=dev-java/junit-3.8*"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	find "${S}" '(' -name '*.class' -o -name '*.jar' ')' -print -delete
	rm "${S}/doc/LICENSE.TXT" || die "Failed to remove LICENSE.TXT"
}

src_compile() {
	cd "${S}"/src
	eant jar -Dftp.classpath=$(java-pkg_getjars junit) $(use_doc javadocs)
}

src_install() {
	java-pkg_dojar lib/*.jar

	use doc && java-pkg_dojavadoc build/doc/api
	use source && java-pkg_dosrc src/com
	use examples && java-pkg_doexamples examples
}
