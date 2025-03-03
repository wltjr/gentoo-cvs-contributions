# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/syck-php-bindings/syck-php-bindings-0.55.ebuild,v 1.4 2007/03/06 22:13:35 chtekk Exp $

PHP_EXT_NAME="syck"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-source-r1

KEYWORDS="amd64 x86"

MY_P="syck-${PV}"

DESCRIPTION="PHP bindings for Syck - an extension for reading and writing YAML swiftly in popular scripting languages."
HOMEPAGE="http://whytheluckystiff.net/syck/"
SRC_URI="http://rubyforge.org/frs/download.php/4492/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="~dev-libs/syck-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/ext/php"

need_php_by_category
