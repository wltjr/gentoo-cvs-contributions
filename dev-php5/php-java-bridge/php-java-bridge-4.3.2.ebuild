# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/php-java-bridge/php-java-bridge-4.3.2.ebuild,v 1.1 2007/12/24 14:47:41 armin76 Exp $

PHP_EXT_NAME="java"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-source-r1

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="The PHP/Java bridge is a PHP module wich connects the PHP object system with the Java or ECMA 335 object system."
HOMEPAGE="http://php-java-bridge.sourceforge.net/"
SRC_URI="mirror://sourceforge/php-java-bridge/${PN}_${PV}.tar.gz"
LICENSE="PHP-3"
SLOT="0"
IUSE="doc examples"

DEPEND=">=virtual/jdk-1.4.2"
RDEPEND="${DEPEND}"

need_php_by_category

pkg_setup() {
	require_php_with_use session
}

src_compile() {
	my_conf="--disable-servlet --with-java=$(java-config --jdk-home)"
	php-ext-source-r1_src_compile
}

src_install() {
	php-ext-source-r1_src_install

	insinto "${EXT_DIR}"
	doins modules/JavaBridge.jar
	doins modules/RunJavaBridge
	doins modules/java.so

	dodoc-php CREDITS ChangeLog README README.GNU_JAVA PROTOCOL.TXT \
		php_java_lib/{JPersistence,JSession,JspTag,java_helper,jikes_compiler}.php php_java_lib/README.txt

	if use doc ; then
		insinto /usr/share/doc/${CATEGORY}/${PF}
		doins -r documentation/API
	fi

	if use examples ; then
		insinto /usr/share/doc/${CATEGORY}/${PF}
		doins -r examples
	fi
}
