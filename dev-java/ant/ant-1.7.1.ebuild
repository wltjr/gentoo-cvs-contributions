# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant/ant-1.7.1.ebuild,v 1.2 2008/07/14 22:18:28 caster Exp $

EAPI="1"

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files."
HOMEPAGE="http://ant.apache.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="~dev-java/ant-core-${PV}
	~dev-java/ant-tasks-${PV}"
RDEPEND="${DEPEND}"

IUSE="X +antlr +bcel +bsf +commonslogging +commonsnet jai +javamail +jdepend jmf
	+jsch +log4j +oro +regexp +resolver"

RDEPEND="~dev-java/ant-core-${PV}
	~dev-java/ant-nodeps-${PV}
	~dev-java/ant-junit-${PV}
	!dev-java/ant-optional
	!dev-java/ant-tasks
	~dev-java/ant-trax-${PV}
	antlr? ( ~dev-java/ant-antlr-${PV} )
	bcel? ( ~dev-java/ant-apache-bcel-${PV} )
	bsf? ( ~dev-java/ant-apache-bsf-${PV} )
	log4j? ( ~dev-java/ant-apache-log4j-${PV} )
	oro? ( ~dev-java/ant-apache-oro-${PV} )
	regexp? ( ~dev-java/ant-apache-regexp-${PV} )
	resolver? ( ~dev-java/ant-apache-resolver-${PV} )
	commonslogging? ( ~dev-java/ant-commons-logging-${PV} )
	commonsnet? ( ~dev-java/ant-commons-net-${PV} )
	jai? ( ~dev-java/ant-jai-${PV} )
	javamail? ( ~dev-java/ant-javamail-${PV} )
	jdepend? ( ~dev-java/ant-jdepend-${PV} )
	jmf? ( ~dev-java/ant-jmf-${PV} )
	jsch? ( ~dev-java/ant-jsch-${PV} )
	X? ( ~dev-java/ant-swing-${PV} )"

DEPEND=""

S="${WORKDIR}"

src_compile() { :; }

pkg_postinst() {
	elog "Since 1.7.1, the ant-tasks meta-ebuild has been removed and its USE"
	elog "flags have been moved to dev-java/ant."
	elog
	elog "You may now freely set the USE flags of this package without breaking"
	elog "building of Java packages, which depend on the exact ant tasks they need."
	elog "The USE flags default to enabled (except X, jai and jmf) for convenience."
}
