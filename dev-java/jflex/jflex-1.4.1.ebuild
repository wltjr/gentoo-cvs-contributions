# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jflex/jflex-1.4.1.ebuild,v 1.2 2008/01/10 22:34:32 caster Exp $

# Currently, this package uses an included JFlex.jar file to bootstrap.
# Upstream was contacted and this bootstrap is really needed. The only way to avoid it would be to use a supplied pre-compiled .scanner file.

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JFlex is a lexical analyzer generator for Java"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.jflex.de/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND=">=virtual/jre-1.4
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	>=dev-java/ant-core-1.7.0
	>=dev-java/javacup-0.11a_beta20060608"

DEPEND=">=virtual/jdk-1.4
	=dev-java/junit-3.8*
	>=dev-java/javacup-0.11a_beta20060608"

IUSE="doc source vim-syntax"

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/src"
	epatch "${FILESDIR}/${P}-build.xml.patch"

	mkdir "${S}/tools"
	cp "${S}/lib/JFlex.jar" "${S}/tools/JFlex.jar"
	rm -rf java_cup "${S}/lib/JFlex.jar"

	java-ant_rewrite-classpath
}

src_compile() {
	ANT_TASKS="javacup"
	jflex_cp="$(java-pkg_getjars --build-only junit):$(java-pkg_getjars ant-core,javacup)"
	cd "${S}/src"
	eant realclean
	eant -Dgentoo.classpath="${jflex_cp}" jar

	rm "${S}/tools/JFlex.jar"
	cp "${S}/lib/JFlex.jar" "${S}/tools/"
	rm "${S}/lib/JFlex.jar"

	eant realclean
	einfo "Recompiling using the newly generated JFlex library"
	eant -Dgentoo.classpath="${jflex_cp}" jar
}

src_install() {
	java-pkg_dojar lib/JFlex.jar
	java-pkg_dolauncher "${PN}" --main JFlex.Main
	java-pkg_register-ant-task

	dodoc doc/manual.pdf doc/manual.ps.gz src/changelog
	dohtml -r doc/*

	use source && java-pkg_dosrc src/JFlex

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}/lib/jflex.vim"
	fi
}
