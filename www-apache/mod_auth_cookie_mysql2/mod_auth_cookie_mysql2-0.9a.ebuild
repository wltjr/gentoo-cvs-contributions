# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_auth_cookie_mysql2/mod_auth_cookie_mysql2-0.9a.ebuild,v 1.3 2008/03/23 00:02:10 hollow Exp $

inherit eutils apache-module

KEYWORDS="~x86"

DESCRIPTION="An Apache2 backend authentication module that uses cookies and MySQL."
HOMEPAGE="http://home.digithi.de/digithi/dev/mod_auth_cookie_mysql/"
SRC_URI="http://home.digithi.de/digithi/dev/mod_auth_cookie_mysql/${P/-/_}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/mysql"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/-/_}"

APXS2_ARGS="-I/usr/include/mysql -lmysqlclient -lz -c ${PN}.c"

APACHE2_MOD_CONF="55_${PN}"
APACHE2_MOD_DEFINE="AUTH_COOKIE_MYSQL2"

DOCFILES="README mod_auth_cookie_mysql.html"

need_apache2
