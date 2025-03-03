# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/joomla/joomla-1.0.15.ebuild,v 1.1 2008/02/23 20:51:25 hollow Exp $

inherit webapp depend.php

DESCRIPTION="Joomla is a powerful Open Source Content Management System."
HOMEPAGE="http://www.joomla.org/"
SRC_URI="http://downloads.joomlacode.org/frsrelease/2/2/5/22536/Joomla_${PV}-Stable-Full_Package.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

need_httpd_cgi
need_php_httpd

S="${WORKDIR}"

pkg_setup () {
	webapp_pkg_setup
	require_php_with_use mysql zlib
}

src_install () {
	webapp_src_preinst

	dodoc CHANGELOG.php INSTALL.php

	touch configuration.php
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	local files="administrator/backups administrator/components
	administrator/modules administrator/templates cache components images
	images/banners images/stories language mambots mambots/content
	mambots/editors mambots/editors-xtd mambots/search mambots/system media
	modules templates"

	for file in ${files}; do
		webapp_serverowned "${MY_HTDOCSDIR}"/${file}
	done

	webapp_configfile "${MY_HTDOCSDIR}"/configuration.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
