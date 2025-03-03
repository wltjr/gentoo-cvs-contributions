# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/resin-servlet-api/resin-servlet-api-3.1.6.ebuild,v 1.2 2008/05/10 21:44:18 nelchael Exp $

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Resin Servlet API 2.5/JSP API 2.1 implementation"
HOMEPAGE="http://www.caucho.com/"
SRC_URI="http://www.caucho.com/download/resin-${PV}-src.zip
	mirror://gentoo/resin-gentoo-patches-${PV}-1.tar.bz2"

LICENSE="GPL-2"
SLOT="2.5"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/resin-${PV}"

src_unpack() {

	unpack ${A}

	mkdir "${S}/lib"

	cd "${S}"
	epatch "${WORKDIR}/${PV}/resin-${PV}-build.xml.patch" || die

}

EANT_BUILD_TARGET="jsdk"
EANT_DOC_TARGET=""

src_install() {

	java-pkg_newjar "lib/jsdk-15.jar"
	use source && java-pkg_dosrc "${S}"/modules/jsdk/src/*

}
