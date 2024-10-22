# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sguil-server/sguil-server-0.6.1-r1.ebuild,v 1.1 2007/12/30 20:08:38 ulm Exp $

inherit eutils ssl-cert

MY_PV="${PV/_p/p}"
DESCRIPTION="Daemon for Sguil Network Security Monitoring"
HOMEPAGE="http://sguil.sourceforge.net"
SRC_URI="mirror://sourceforge/sguil/sguil-server-${MY_PV}.tar.gz"
LICENSE="QPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl"

DEPEND=">=dev-lang/tcl-8.3
	>=dev-tcltk/tclx-8.3
	dev-tcltk/tcllib
	dev-tcltk/mysqltcl
	ssl? ( >=dev-tcltk/tls-1.4.1 )"
RDEPEND="${DEPEND}
	net-analyzer/p0f
	net-analyzer/tcpflow
	net-misc/openssh"

S="${WORKDIR}/sguil-${MY_PV}"

pkg_setup() {
	if built_with_use dev-lang/tcl threads ; then
		eerror
		eerror "Sguil does not run when tcl was built with threading enabled."
		eerror "Please rebuild tcl without threads and reemerge this ebuild."
		eerror
		die
	fi
	enewgroup sguil
	enewuser sguil -1 -1 /var/lib/sguil sguil
}

src_unpack(){
	unpack ${A}
	cd "${S}"/server
	sed -i -e 's:DEBUG 2:DEBUG 1:' -e 's:DAEMON 0:DAEMON 1:' \
		-e 's:SGUILD_LIB_PATH ./lib:SGUILD_LIB_PATH /usr/lib/sguild:g' \
		-e 's:/sguild_data/rules:/var/lib/sguil/rules:g' \
		-e 's:/sguild_data/archive:/var/lib/sguil/archive:g' \
		sguild.conf || die "sed failed"
	sed -i -e 's:set VERSION "SGUIL-0.6.0":set VERSION "SGUIL-0.6.0p1":' \
		sguild || die "sed failed"
}

src_install(){
	dodoc server/sql_scripts/*
	dodoc doc/CHANGES doc/OPENSSL.README doc/USAGE doc/INSTALL \
	doc/TODO doc/sguildb.dia

	insopts -m640
	insinto /etc/sguil
	doins server/{sguild.email,sguild.users,sguild.conf,sguild.queries,sguild.access,autocat.conf}

	insinto /usr/lib/sguild
	doins server/lib/*
	dobin server/sguild
	newinitd "${FILESDIR}/sguild.initd" sguild
	newconfd "${FILESDIR}/sguild.confd" sguild

	if use ssl; then
		sed -i -e "s/#OPENSSL/OPENSSL/" "${D}/etc/conf.d/sguild"
	fi

	diropts -g sguil -o sguil
	keepdir /var/run/sguil \
		/var/lib/sguil \
		/var/lib/sguil/archive \
		/var/lib/sguil/rules

}

pkg_postinst(){
	if use ssl && ! [ -f "${ROOT}"/etc/sguil/sguild.key ]; then
		install_cert /etc/sguil/sguild
	fi

	chown -R sguil:sguil "${ROOT}"/etc/sguil/sguild.*
	chown -R sguil:sguil "${ROOT}"/usr/lib/sguild

	if [ -d "${ROOT}"/etc/snort/rules ] ; then
		ln -s /etc/snort/rules "${ROOT}"/var/lib/sguil/rules/${HOSTNAME}
	fi

	elog
	elog "Please customize the sguild configuration files in /etc/sguild before"
	elog "trying to run the daemon. Additionally you will need to setup the"
	elog "mysql database. See /usr/share/doc/${PF}/INSTALL.gz for information."
	elog "Please note that it is STRONGLY recommended to mount a separate"
	elog "filesystem at /var/lib/sguil for both space and performance reasons"
	elog "as a large amount of data will be kept in the directory structure"
	elog "underneath that top directory."
	elog
	elog "You should create the sguild db as per the instructions in"
	elog "/usr/share/doc/${PF}/INSTALL.gz and use the appropriate"
	elog "database setup script located in the same directory."

	elog
}
