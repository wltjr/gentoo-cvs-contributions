# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/aimsniff/aimsniff-0.9-r2.ebuild,v 1.9 2008/02/05 10:30:08 hollow Exp $

inherit eutils webapp eutils depend.apache

MY_P="${P}d"
WAS_VER="0.1.2b"

DESCRIPTION="Utility for monitoring and archiving AOL Instant Messenger messages across a network"
HOMEPAGE="http://www.aimsniff.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	http? ( mirror://sourceforge/${PN}/was-${WAS_VER}.tar.gz )"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc x86"
#SLOT empty due to webapp
IUSE="samba mysql http"

DEPEND="dev-lang/perl
	dev-perl/Net-Pcap
	dev-perl/NetPacket
	dev-perl/Unicode-String
	dev-perl/FileHandle-Rollback
	dev-perl/Proc-Daemon
	dev-perl/Proc-Simple
	dev-perl/DBI
	dev-perl/Unix-Syslog
	mysql? ( virtual/mysql dev-perl/DBD-mysql )
	samba? ( net-fs/samba )"

want_apache2 http

RESTRICT="mirror"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use http
	then
		webapp_pkg_setup
	fi

	built_with_use dev-lang/perl gdbm || \
		die "${PN} requires that dev-lang/perl be built with USE=gdbm."
}

src_install() {
	if use http
	then
		webapp_src_preinst
	fi

	newsbin aimSniff.pl aimsniff
	insinto /etc/${PN}
	doins aimsniff.config
	insinto /usr/share/doc/${PF}
	doins table.struct
	dodoc README ChangeLog

	if use http
	then
		cp ../was-${WAS_VER}/docs/README README.WAS
		dodoc README.WAS

		rm -rf ../was-${WAS_VER}/docs
		mv ../was-${WAS_VER}/ "${D}"${MY_HTDOCSDIR}/was

		webapp_serverowned ${MY_HTDOCSDIR}/was

		# This file needs to be serverowned as the server won't be able to write to it if it were
		# webapp_configfile'ed.
		webapp_serverowned ${MY_HTDOCSDIR}/was/.config.php

		for phpfile in `ls -a "${D}"${MY_HTDOCSDIR}/was/ | grep ".php$"`; do
			webapp_runbycgibin php ${MY_HTDOCSDIR}/was/${phpfile}
		done

		webapp_src_install
	fi

	newinitd "${FILESDIR}"/aimsniff.rc aimsniff
}

pkg_postinst() {
	if use mysql
	then
		echo
		elog "To create and enable the mysql database, please run: "
		elog "emerge --config =${PF}"

		if use http
		then
			echo "To create and enable the mysql database, please run:
			emerge --config =${PF}" > apache-postinst
			webapp_postinst_txt en apache-postinst
		fi
	fi

	if use http
	then
		elog
		elog "Go to http://${HOSTNAME}/was/admin.php to configure WAS."

		echo "Go to http://${HOSTNAME}/was/admin.php to configure WAS." > was-postinst
		webapp_postinst_txt en was-postinst
	fi
}

pkg_config() {
	echo
	einfo "Creating mysql database aimsniff using /usr/share/doc/${PF}/table.struct:"
	echo -n "Please enter your mysql root password: "
	read mysql_root
	/usr/bin/mysqladmin -p$mysql_root -u root create aimsniff
	/usr/bin/mysql -p$mysql_root -u root aimsniff < /usr/share/doc/${PF}/table.struct
	echo -n "Please enter your username that you want to connect to the database with: "
	read user
	echo -n "Please enter the password that you want to use for your database: "
	read password
	einfo "Granting permisions on database using 'GRANT ALL ON aimsniff.* TO $user IDENTIFIED BY '$password';'"
	echo "GRANT ALL ON aimsniff.* TO $user@localhost IDENTIFIED BY '$password';" | /usr/bin/mysql -p$mysql_root -u root aimsniff
	echo
}
