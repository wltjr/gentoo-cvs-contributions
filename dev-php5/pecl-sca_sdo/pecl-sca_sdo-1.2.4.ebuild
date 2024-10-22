# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-sca_sdo/pecl-sca_sdo-1.2.4.ebuild,v 1.1 2008/03/17 09:56:39 jokey Exp $

PHP_EXT_NAME="sdo"
PHP_EXT_PECL_PKG="SCA_SDO"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1 depend.php

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Service Component Architecture (SCA) and Service Data Objects (SDO) for PHP."
LICENSE="Apache-2.0"
SLOT="0"
IUSE="examples"

DEPEND=""
RDEPEND=""

need_php_by_category

pkg_setup() {
	require_php_with_use json reflection soap spl xml
}

src_install() {
	php-ext-pecl-r1_src_install

	insinto /usr/share/php5
	doins -r DAS SCA
}
