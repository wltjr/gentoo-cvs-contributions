# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/asterisk/asterisk-1.0.5-r2.ebuild,v 1.6 2005/07/25 22:22:48 stkn Exp $

inherit eutils perl-module

ADDONS_VERSION="1.0.4"

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="ftp://ftp.asterisk.org/pub/telephony/${PN}/old-releases/${P}.tar.gz
	 ftp://ftp.asterisk.org/pub/telephony/${PN}/old-releases/${PN}-addons-${ADDONS_VERSION}.tar.gz"

S_ADDONS=${WORKDIR}/${PN}-addons-${ADDONS_VERSION}

IUSE="alsa doc gtk mmx mysql pri zaptel uclibc resperl debug postgres vmdbmysql vmdbpostgres"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~hppa ~amd64"

DEPEND="dev-libs/newt
	dev-libs/openssl
	media-sound/mpg123
	media-sound/sox
	doc? ( app-doc/doxygen )
	gtk? ( =x11-libs/gtk+-1.2* )
	pri? ( >=net-libs/libpri-1.0.4-r1 )
	alsa? ( media-libs/alsa-lib )
	mysql? ( dev-db/mysql )
	uclibc? ( sys-libs/uclibc )
	zaptel? ( >=net-misc/zaptel-1.0.4-r1 )
	resperl? ( dev-lang/perl
		   >=net-misc/zaptel-1.0.4-r1 )
	postgres? ( dev-db/postgresql )
	vmdbmysql? ( dev-db/mysql )
	vmdbpostgres? ( dev-db/postgresql )"


pkg_setup() {
	local n

	#
	# Warning about security changes...
	#
	ewarn "****************** Important changes warning! *********************"
	ewarn
	ewarn "- Asterisk runs as user asterisk, group asterisk by default"
	ewarn
	ewarn "- Permissions of /etc/asterisk have been changed to root:asterisk"
	ewarn "  750 (directories) / 640 (files)"
	ewarn
	ewarn "- Permissions of /var/{log,lib,run,spool}/asterisk have been changed"
	ewarn "  to asterisk:asterisk 750 (directories) / 640 (files)"
	ewarn
	ewarn "- Asterisk's unix socket and pidfile are now in /var/run/astrisk"
	ewarn
	ewarn "- More information at the end of this emerge"
	ewarn
	ewarn "     http://bugs.gentoo.org/show_bug.cgi?id=88732"
	ewarn "     http://www.voip-info.org/wiki-Asterisk+non-root"
	ewarn
	echo
	einfo "Press Ctrl+C to abort"
	echo
	ebeep

	n=15
	while [[ $n -gt 0 ]]; do
		echo -en "  Waiting $n seconds...\r"
		sleep 1
		(( n-- ))
	done

	einfo "Running some pre-flight checks..."
	if use resperl; then
		# res_perl pre-flight check...
		if ! $(perl -V | grep -q "usemultiplicity=define"); then
			eerror "Embedded perl add-on needs Perl with built-in threads support"
			eerror "(rebuild perl with ithreads use-flag enabled)"
			die "Perl w/o threads support..."
		fi
		einfo "Perl with ithreads support found"
	fi


	# mysql and postgres voicemail support are mutually exclusive..
	if use vmdbmysql && use vmdbpostgres; then
		eerror "MySQL and PostgreSQL Voicemail support are mutually exclusive... choose one!"
		die "Conflicting use-flags"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# set cflags & mmx optimization
	sed -i  -e "s:^\(OPTIMIZE+=\).*:\1 ${CFLAGS}:" \
		-e "s:^\(CFLAGS+=\$(shell if \$(CC)\):#\1:" \
		Makefile

	# gsm codec still uses -fomit-frame-pointer, and other codecs have their
	# own flags. We only change the arch.
	sed -i -e "s:^OPTIMIZE+=.*:OPTIMIZE+=${CFLAGS}:" codecs/gsm/Makefile

	if use mmx; then
		einfo "enabling mmx optimization"
		sed -i -e "s:^#\(K6OPT.*\):\1:" Makefile
		sed -i -e "s:^#\(K6OPT[\t ]\+= -DK6OPT\):\1:" codecs/gsm/Makefile
	fi

	if ! use debug; then
		einfo "disabling debugging"
		sed -i -e "s:^\(DEBUG=\):#\1:" Makefile
	fi

	# change image path in voicemail cgi
	sed -i -e "s:^\(\$astpath = \).*:\1 \"/asterisk\";:" contrib/scripts/vmail.cgi

	#
	# embedded perl
	#
	if use resperl; then
		einfo "Patching asterisk for embedded perl support..."
		epatch ${S_ADDONS}/res_perl/astmake.diff

		# create necessary .c file
		/usr/bin/perl -MExtUtils::Embed -e xsinit || die "Could not create perlxsi.c"

		cd ${S_ADDONS}

		# fix perl path, source location and remove res_musiconhold
		sed -i -e "s:/usr/local/bin/perl:/usr/bin/perl:" \
			res_perl/Makefile \
			${S}/Makefile \
			res_perl/INC/*.pm
		sed -i -e "s:^ASTSRC.*:ASTSRC = ${S}:" \
			-e "s:\$(ASTLIBDIR)/modules/res_musiconhold.so::" \
			res_perl/Makefile

		cd ${S}
	fi

	#
	# uclibc patch
	#
	if use elibc_uclibc; then
		einfo "Patching asterisk for uclibc..."
		epatch ${FILESDIR}/1.0.0/${P}-uclibc-dns.diff
	fi

	#
	# other patches
	#

	# asterisk-config
	epatch ${FILESDIR}/1.0.0/${P}-astcfg-0.0.2.diff

	# fix include path for speex >= 1.1.0
	epatch ${FILESDIR}/1.0.0/${P}-speex.diff

	# hppa build fix
	epatch ${FILESDIR}/1.0.0/${P}-hppa.patch

	#
	# database voicemail support
	#
	if use postgres; then
		sed -i  -e "s:^#\(APPS+=app_sql_postgres.so\):\1:" \
			-e "s:/usr/local/pgsql/include:/usr/include/postgresql/pgsql:" \
			-e "s:/usr/local/pgsql/lib:/usr/lib/postgresql:" \
			apps/Makefile
	fi

	if use vmdbpostgres; then
		einfo "Enabling PostgreSQL voicemail support"
		sed -i  -e "s:^\(USE_POSTGRES_VM_INTERFACE\).*:\1=1:" \
			-e "s:/usr/local/pgsql/include:/usr/include/postgresql/pgsql:" \
			-e "s:/usr/local/pgsql/lib:/usr/lib/postgresql:" \
			apps/Makefile

		# patch app_voicemail.c
		sed -i -e "s:^#include <postgresql/libpq-fe\.h>:#include \"libpq-fe\.h\":" \
			apps/app_voicemail.c

	elif use vmdbmysql; then
		einfo "Enabling MySQL voicemail support"
		sed -i  -e "s:^\(USE_MYSQL_VM_INTERFACE\).*:\1=1:" \
			-e "s:^\(CFLAGS+=-DUSEMYSQLVM\):\1 -I${S_ADDONS}:" \
			apps/Makefile
	fi

	#
	# asterisk add-ons
	#
	cd ${S_ADDONS}
	sed -i -e "s:-I../asterisk:-I${S} -I${S}/include:" Makefile
	sed -i  -e "s:^OPTIMIZE+=.*:OPTIMIZE+=${CFLAGS}:" \
		-e "s:^\(CFLAGS=\)\(.*\):\1-I${S}/include -fPIC \2:" \
		format_mp3/Makefile

	# fix path for non-root
	cd ${S}
	sed -i -e "s:^\(ASTVARRUNDIR=\).*:\1\$(INSTALL_PREFIX)/var/run/asterisk:" \
		Makefile

	# fix contrib scripts for non-root
	epatch ${FILESDIR}/1.0.0/${PN}-1.0.7-scripts.diff

	# add initgroups support to asterisk, this is needed
	# to support supplementary groups for the asterisk
	# user (start-stop-daemons --chguid breaks realtime priority support)
	epatch ${FILESDIR}/1.0.0/${PN}-1.0.7-initgroups.diff

	# security fix (www.portcullis-security.com/advisory/advisory-05-013.txt)
	epatch ${FILESDIR}/1.0.0/${PN}-1.0.7-manager-cli-segv.patch
}

src_compile() {
	# build asterisk first...
	einfo "Building Asterisk..."
	cd ${S}
	emake -j1 || die "Make failed"

	# documentation
	use doc && \
		emake -j1 DESTDIR=${D} progdocs

	#
	# add-ons
	#
	einfo "Building additional stuff..."
	cd ${S_ADDONS}
	emake -j1 || die "Make failed"

	if use resperl; then
		cd ${S_ADDONS}/res_perl
		emake -j1 || die "Building embedded perl failed"
	fi
}

src_install() {
	make DESTDIR=${D} install || die "Make install failed"
	make DESTDIR=${D} samples || die "Make install samples failed"

	# install astconf.h, a lot of external modules need this
	insinto /usr/include/asterisk
	doins   astconf.h

	# install addmailbox and astgenkey
	dosbin contrib/scripts/addmailbox
	dosbin contrib/scripts/astgenkey

	newinitd  ${FILESDIR}/1.0.0/asterisk.rc6.sec asterisk
	newconfd  ${FILESDIR}/1.0.0/asterisk.confd.sec asterisk

	# don't delete these, even if they are empty
	keepdir /var/spool/asterisk/voicemail/default/1234/INBOX
	keepdir /var/spool/asterisk/tmp
	keepdir /var/log/asterisk/cdr-csv
	keepdir /var/run/asterisk

	# install standard docs...
	dodoc BUGS CREDITS LICENSE ChangeLog HARDWARE README README.fpm SECURITY

	# install api docs
	if use doc; then
		insinto /usr/share/doc/${PF}/api/html
		doins doc/api/html/*
	fi

	docinto scripts
	dodoc contrib/scripts/*
	docinto firmware/iax
	dodoc contrib/firmware/iax/*

	insinto /usr/share/doc/${PF}/cgi
	doins contrib/scripts/vmail.cgi
	doins images/*.gif

	#
	# add-ons
	#

	# install additional modules...
	einfo "Installing additional modules..."
	cd ${S_ADDONS}
	make INSTALL_PREFIX=${D} install || die "Make install failed"

	if use resperl; then
		perlinfo

		cd ${S_ADDONS}/res_perl
		make INSTALL_PREFIX=${D} install || die "Installation of perl AST_API failed"

		# move AstApiBase.so to a proper place
		dodir ${VENDOR_LIB}/auto/AstAPIBase
		mv ${D}/etc/asterisk/perl/AstAPIBase.so ${D}${VENDOR_LIB}/auto/AstAPIBase

		# move *.pm files to other location
		dodir ${VENDOR_LIB}/AstAPI
		dodir ${VENDOR_LIB}/AstAPIBase
		for x in AstAPI.pm AstConfig.pm LoadFile.pm PerlSwitch.pm WebServer.pm; do
			mv ${D}/etc/asterisk/perl/${x} ${D}${VENDOR_LIB}/AstAPI
			dosed "s/^use[\t ]\+${x/.pm/};/use AstAPI::${x/.pm/};/" /etc/asterisk/perl/asterisk_init.pm
		done
		mv ${D}/etc/asterisk/perl/AstAPIBase.pm ${D}${VENDOR_LIB}/AstAPIBase
		dosed "s/^use[\t ]\+AstAPI;/use AstAPI::AstAPI;/" /etc/asterisk/perl/asterisk_init.pm
		dosed "s/^use[\t ]\+AstAPIBase;/use AstAPIBase::AstAPIBase;/" ${VENDOR_LIB}/AstAPI/AstAPI.pm

		# move apps + htdocs to a proper place
		dodir /var/lib/asterisk/perl
		mv ${D}/etc/asterisk/perl/{apps,htdocs} ${D}/var/lib/asterisk/perl

		# fix locations
		sed -i -e "s:/etc/asterisk/perl:/var/lib/asterisk/perl:" \
			${D}${VENDOR_LIB}/AstAPI/LoadFile.pm ${D}${VENDOR_LIB}/AstAPI/WebServer.pm
	fi
}

pkg_preinst() {
	einfo "Adding asterisk user and group"
	enewgroup asterisk
	enewuser asterisk -1 /bin/false /var/lib/asterisk asterisk
}

pkg_postinst() {
	#
	# Change permissions and ownerships of asterisk
	# directories and files
	#
	einfo "Fixing permissions and ownerships"
	# fix permissions in /var/...
	for x in spool run lib log; do
		chown -R asterisk:asterisk ${ROOT}/var/${x}/asterisk
		chmod -R u=rwX,g=rX,o=     ${ROOT}/var/${x}/asterisk
	done

	chown -R root:asterisk ${ROOT}/etc/asterisk
	chmod -R u=rwX,g=rX,o= ${ROOT}/etc/asterisk

	#
	# Fix locations for old installations (pre-non-root versions)
	#
	if [[ -z "$(grep "/var/run/asterisk" ${ROOT}/etc/asterisk/asterisk.conf)" ]]
	then
		einfo "Fixing astrundir in ${ROOT}/etc/asterisk/asterisk.conf"
		mv -f ${ROOT}/etc/asterisk/asterisk.conf \
			${ROOT}/etc/asterisk/asterisk.conf.bak
		sed -e "s:^\(astrundir[\t ]=>\).*:\1 /var/run/asterisk:" \
			${ROOT}/etc/asterisk/asterisk.conf.bak >\
			${ROOT}/etc/asterisk/asterisk.conf
		einfo "Backup has been saved as ${ROOT}/etc/asterisk/asterisk.conf.bak"
	fi

	#
	# Some messages
	#
	einfo "Asterisk has been installed"
	einfo ""
	einfo "to add new Mailboxes use: /usr/sbin/addmailbox"
	einfo ""
	einfo "If you want to know more about asterisk, visit these sites:"
	einfo "http://www.automated.it/guidetoasterisk.htm"
	einfo "http://asterisk.xvoip.com/"
	einfo "http://www.voip-info.org/wiki-Asterisk"
	einfo "http://ns1.jnetdns.de/jn/relaunch/asterisk/"
	echo
	ewarn "Additional sounds have been split-out into"
	ewarn "net-misc/asterisk-sounds"

	#
	# Warning about security changes...
	#
	ewarn "*********************** Important changes **************************"
	ewarn
	ewarn "- Asterisk runs as user asterisk, group asterisk by default"
	ewarn "  Use usermod -G to make the asterisk user a member of additional"
	ewarn "  groups if necessary."
	ewarn
	ewarn "- Make sure the asterisk user is a member of the proper groups if you want it"
	ewarn "  to have access to hardware devices, e.g. \"audio\" for Alsa and OSS sound or"
	ewarn "  \"dialout\" for zaptel!"
	ewarn
	ewarn "- Permissions of /etc/asterisk have been changed to root:asterisk"
	ewarn "  750 (rwxr-x--- directories) / 640 (rw-r----- files)"
	ewarn
	ewarn "- Permissions of /var/{log,lib,run,spool}/asterisk have been changed"
	ewarn "  to asterisk:asterisk 750 / 640"
	ewarn
	ewarn "- Asterisk's unix socket and pidfile are now in /var/run/asterisk"
	ewarn
	ewarn "- Asterisk cannot set the IP ToS bits when run as user,"
	ewarn "  use something like this to make iptables set them for you:"
	ewarn "  \"iptables -A OUTPUT -t mangle -p udp -m udp --dport 5060 -j DSCP --set-dscp 0x28\""
	ewarn "  \"iptables -A OUTPUT -t mangle -p udp -m udp --sport 10000:20000 -j DSCP --set-dscp 0x28\""
	ewarn "  (taken from voip-info.org comments (see below), thanks andrewid)"
	ewarn
	ewarn "For more details:"
	ewarn "     http://bugs.gentoo.org/show_bug.cgi?id=88732"
	ewarn "     http://www.voip-info.org/wiki-Asterisk+non-root"
}
