# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/freemind/freemind-0.9.0_beta16.ebuild,v 1.1 2008/03/09 17:38:30 betelgeuse Exp $

EAPI=1

# will handle rewriting myself
JAVA_PKG_BSFIX="off"
WANT_ANT_TASKS="ant-nodeps ant-trax"
inherit java-pkg-2 java-ant-2 eutils

MY_PV=${PV//beta/Beta_}

DESCRIPTION="Mind-mapping software written in Java"
HOMEPAGE="http://freemind.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${MY_PV}_icon_butterfly.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"
COMMON_DEP="dev-java/jgoodies-forms
	dev-java/jibx
	>=dev-java/simplyhtml-0.12.2_pre20071101
	dev-java/commons-lang:2.1
	dev-java/javahelp
	dev-java/groovy
	=dev-java/batik-1.6*
	>=dev-java/fop-0.93
	dev-java/hoteqn"
DEPEND=">=virtual/jdk-1.4
	dev-java/xsd2jibx
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# kill the jarbundler taskdef
	epatch "${FILESDIR}/${PN}-0.9.0_beta15-build.xml.patch"

	local xml
	for xml in $(find . -name 'build*.xml'); do
		java-ant_rewrite-classpath ${xml}
		java-ant_bsfix_one ${xml}
	done
	rm -v lib/*.jar lib/*.zip lib/*/*.jar \
		plugins/*/*.jar plugins/*/*/*.jar || die
}

src_compile() {
	local jibxlibs="$(java-pkg_getjars --build-only --with-dependencies xsd2jibx)"
	local gcp="$(java-pkg_getjars jgoodies-forms,jibx,commons-lang-2.1,javahelp,groovy-1,batik-1.6,fop,simplyhtml,hoteqn):lib/bindings.jar"
	ANT_TASKS="${WANT_ANT_TASKS} jibx xsd2jibx" eant -Djibxlibs="${jibxlibs}" \
		-Dgentoo.classpath="${gcp}" dist browser $(use_doc doc)
}

src_install() {
	cd "${WORKDIR}/bin/dist"
	local dest="/usr/share/${PN}/"

	java-pkg_dojar lib/*.jar

	insinto "${dest}"
	doins -r accessories browser/ doc/ plugins/ patterns.xml || die

	use doc && java-pkg_dojavadoc doc/javadoc

	java-pkg_dolauncher ${PN} --java_args "-Dfreemind.base.dir=${dest}" \
		--pwd "${dest}" --main freemind.main.FreeMindStarter

	newicon "${S}/images/FreeMindWindowIcon.png" freemind.png

	make_desktop_entry freemind Freemind freemind Utility
}
