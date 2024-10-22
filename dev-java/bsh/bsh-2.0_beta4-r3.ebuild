# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bsh/bsh-2.0_beta4-r3.ebuild,v 1.6 2008/02/15 04:00:22 betelgeuse Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils java-ant-2

MY_PV=${PV/_beta/b}
MY_DIST=${PN}-${MY_PV}-src.jar

DESCRIPTION="BeanShell: A small embeddable Java source interpreter"
HOMEPAGE="http://www.beanshell.org"
SRC_URI="http://www.beanshell.org/${MY_DIST} mirror://gentoo/beanshell-icon.png"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd"
IUSE="bsf readline"
# some tests fail but ant doesn't fail
RESTRICT="test"

RDEPEND=">=virtual/jdk-1.4
	dev-java/servletapi:2.4
	readline? ( dev-java/libreadline-java:0 )"
DEPEND="${RDEPEND}
	bsf? ( dev-java/bsf:2.3 )"

S=${WORKDIR}/BeanShell-${MY_PV}

src_unpack() {
	jar xf ${DISTDIR}/${MY_DIST} || die "failed to unpack"
	cd "${S}"

	epatch "${FILESDIR}/bsh${MY_PV}-build.patch"

	use readline && epatch "${FILESDIR}/bsh2-readline.patch"

	cd lib
	rm -v *.jar || die
	java-pkg_jar-from servletapi-2.4
	use readline && java-pkg_jar-from libreadline-java
	use bsf && java-pkg_jar-from --build-only bsf-2.3
}

src_compile() {
	eant $(use bsf && echo -Dexclude-bsf=) jarall $(use_doc)
}

src_test() {
	eant test
}

src_install() {
	java-pkg_newjar dist/${P/_beta/b}.jar

	java-pkg_dolauncher bsh-console --main bsh.Console
	java-pkg_dolauncher bsh-interpreter --main bsh.Interpreter

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/bsh

	newicon ${DISTDIR}/beanshell-icon.png beanshell.png

	make_desktop_entry bsh-console "BeanShell Prompt" beanshell
}
