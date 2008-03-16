# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-primitives/commons-primitives-1.0-r2.ebuild,v 1.7 2008/03/16 17:21:46 betelgeuse Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The Jakarta-Commons Primitives Component"
HOMEPAGE="http://jakarta.apache.org/commons/primitives/"
SRC_URI="mirror://apache/jakarta/commons/primitives/source/${P}-src.tar.gz"
DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

# Would need an old version of commons-collections and this would be the
# only user. Trunk works against the latest version so hopefully they will
# have a new release at some point.
RESTRICT="test"

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/docs/api
	use source && java-pkg_dosrc src/java/*
}
