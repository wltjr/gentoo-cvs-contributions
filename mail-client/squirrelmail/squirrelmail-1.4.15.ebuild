# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/squirrelmail/squirrelmail-1.4.15.ebuild,v 1.1 2008/07/19 11:32:10 dertobi123 Exp $

IUSE="ldap spell ssl filter mysql postgres nls"

inherit webapp eutils

DESCRIPTION="Webmail for nuts!"

# Plugin Versions
COMPATIBILITY_VER=2.0.9-1.0
USERDATA_VER=0.9-1.4.0
ADMINADD_VER=0.1-1.4.0
AMAVIS_VER=0.8.0-1.4
LDAP_USERDATA_VER=0.4
SECURELOGIN_VER=1.3-1.2.8
SHOWSSL_VER=2.2-1.2.8
LOCALES_VER=1.4.13-20071220
DECODING_VER=1.2

MY_P=${P/_rc/-RC}
S="${WORKDIR}/${MY_P}"

PLUGINS_LOC="http://www.squirrelmail.org/plugins"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
	mirror://sourceforge/${PN}/squirrelmail-decode-${DECODING_VER}.tar.bz2
	mirror://sourceforge/retruserdata/retrieveuserdata.${USERDATA_VER}.tar.gz
	${PLUGINS_LOC}/compatibility-${COMPATIBILITY_VER}.tar.gz
	ssl? ( ${PLUGINS_LOC}/secure_login-${SECURELOGIN_VER}.tar.gz )
	ssl? ( ${PLUGINS_LOC}/show_ssl_link-${SHOWSSL_VER}.tar.gz )
	${PLUGINS_LOC}/admin_add.${ADMINADD_VER}.tar.gz
	filter? ( ${PLUGINS_LOC}/amavisnewsql-0.8.0-1.4.tar.gz )
	ldap? ( ${PLUGINS_LOC}/ldapuserdata-${LDAP_USERDATA_VER}.tar.gz )
	nls? ( mirror://sourceforge/${PN}/all_locales-${LOCALES_VER}.tar.bz2 )"

HOMEPAGE="http://www.squirrelmail.org/"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=""

RDEPEND="virtual/php
	virtual/perl-DB_File
	ldap? ( net-nds/openldap )
	spell? ( || ( app-text/aspell app-text/ispell ) )
	filter? ( mail-filter/amavisd-new dev-php/PEAR-Log dev-php/PEAR-DB dev-php/PEAR-Net_SMTP )
	postgres? ( dev-php/PEAR-DB )
	mysql? ( dev-php/PEAR-DB )"

src_unpack() {
	unpack ${MY_P}.tar.bz2
	unpack squirrelmail-decode-${DECODING_VER}.tar.bz2

	cd "${S}"

	mv config/config_default.php config/config.php

	sed -i "s:'/var/local/squirrelmail/data/':SM_PATH . 'data/':" config/config.php

	# Now do the plugins
	cd "${S}/plugins"

	sed -i 's:/usr/games/fortune:/usr/bin/fortune:g' fortune/setup.php || die "Unable to fix fortunes plugin."

	unpack compatibility-${COMPATIBILITY_VER}.tar.gz

	unpack admin_add.${ADMINADD_VER}.tar.gz

	unpack retrieveuserdata.${USERDATA_VER}.tar.gz

	use filter &&
		unpack amavisnewsql-${AMAVIS_VER}.tar.gz &&
		mv amavisnewsql/config.php.dist amavisnewsql/config.php

	use ldap &&
		unpack ldapuserdata-${LDAP_USERDATA_VER}.tar.gz &&
		epatch "${FILESDIR}"/ldapuserdata-${LDAP_USERDATA_VER}-gentoo.patch &&
		mv ldapuserdata/config_sample.php ldapuserdata/config.php

	use ssl &&
		unpack secure_login-${SECURELOGIN_VER}.tar.gz &&
		mv secure_login/config.sample.php secure_login/config.php &&
		unpack show_ssl_link-${SHOWSSL_VER}.tar.gz &&
		mv show_ssl_link/config.php.sample show_ssl_link/config.php

	use nls &&
		cd "${S}" &&
		unpack all_locales-${LOCALES_VER}.tar.bz2
}

src_compile() {
	#we need to have this empty function ... default compile hangs
	echo "Nothing to compile"
}

src_install() {
	webapp_src_preinst

	# handle documentation files
	#
	# NOTE that doc files go into /usr/share/doc as normal; they do NOT
	# get installed per vhost!

	for doc in AUTHORS COPYING ChangeLog INSTALL README ReleaseNotes UPGRADE; do
		dodoc ${doc}
		rm -f ${doc}
	done

	docinto compatibility
	for doc in plugins/compatibility/INSTALL plugins/compatibility/README; do
		dodoc ${doc}
		rm -f ${doc}
	done

	docinto admin_add
	for doc in plugins/admin_add/README; do
		dodoc ${doc}
		rm -f ${doc}
	done

	docinto retrieveuserdata
	for doc in plugins/retrieveuserdata/INSTALL plugins/retrieveuserdata/changelog plugins/retrieveuserdata/users_example.txt; do
		dodoc ${doc}
		rm -f ${doc}
	done

	if use filter; then
		docinto amavisnewsql
		for doc in plugins/amavisnewsql/{CHANGELOG,README,UPGRADE}; do
			dodoc ${doc}
			rm -f ${doc}
		done
	fi

	if use ldap; then
		rm plugins/ldapuserdata/README
		docinto ldapuserdata
		for doc in plugins/ldapuserdata/doc/README; do
			dodoc ${doc}
			rm -f ${doc}
		done
	fi

	if use ssl; then
		docinto secure_login
		for doc in plugins/secure_login/INSTALL plugins/secure_login/README; do
			dodoc ${doc}
			rm -f ${doc}
		done

		docinto show_ssl_link
		for doc in plugins/show_ssl_link/INSTALL plugins/show_ssl_link/README; do
			dodoc ${doc}
			rm -f ${doc}
		done
	fi

	# Copy the app's main files
	einfo "Installing squirrelmail files."
	cp -r . "${D}${MY_HTDOCSDIR}"

	cp "${WORKDIR}"/squirrelmail-decode-${DECODING_VER}/*/*.php "${D}${MY_HTDOCSDIR}/functions/decode"

	# Identify the configuration files that this app uses
	local configs="config/config.php config/config_local.php plugins/retrieveuserdata/config.php"
	use filter && configs="${configs} plugins/amavisnewsql/config.php"
	use ldap && configs="${configs} plugins/ldapuserdata/config.php"
	use ssl && configs="${configs} plugins/show_ssl_link/config.php plugins/secure_login/config.php"

	for file in ${configs}; do
		webapp_configfile ${MY_HTDOCSDIR}/${file}
	done

	# Identify any script files that need #! headers adding to run under
	# a CGI script (such as PHP/CGI)
	#
	# for phpmyadmin, we *assume* that all .php files that don't end in
	# .inc.php need to have CGI/BIN support added

	#for x in `find . -name '*.php' -print | grep -v 'inc.php'` ; do
	#	webapp_runbycgibin php ${MY_HTDOCSDIR}/$x
	#done

	local server_owned="data index.php"
	for file in ${server_owned}; do
		webapp_serverowned ${MY_HTDOCSDIR}/${file}
	done

	# add the post-installation instructions
	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	# all done
	#
	# now we let the eclass strut its stuff ;-)

	webapp_src_install
}
