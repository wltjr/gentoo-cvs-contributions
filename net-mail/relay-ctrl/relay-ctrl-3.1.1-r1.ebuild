# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/relay-ctrl/relay-ctrl-3.1.1-r1.ebuild,v 1.5 2004/05/26 15:59:19 kugelfang Exp $

S=${WORKDIR}/${P}
DESCRIPTION="SMTP Relaying Control designed for qmail & tcpserver."
SRC_URI="http://untroubled.org/relay-ctrl/${P}.tar.gz"
HOMEPAGE="http://untroubled.org/relay-ctrl/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"

DEPEND="sys-devel/gcc-config"
RDEPEND="sys-apps/ucspi-tcp sys-apps/daemontools"

RELAYCTRL_BASE="/var/spool/relay-ctrl"
# this is relative to RELAYCTRL_BASE
RELAYCTRL_STORAGE="allow"
RELAYCTRL_CONFDIR="/etc/relay-ctrl"
RELAYCTRL_BINDIR="/usr/bin"

inherit fixheadtails

src_unpack() {
	unpack ${A}
	ht_fix_file ${S}/Makefile
}

src_compile() {
	echo "${CC} ${CFLAGS}" > conf-cc
	echo "${CC} ${LDFLAGS}" > conf-ld
	emake || die
}

src_install () {
	exeinto ${RELAYCTRL_BINDIR}
	doexe relay-ctrl-age relay-ctrl-allow relay-ctrl-check relay-ctrl-send relay-ctrl-udp relay-ctrl-chdir

	#NB: at some point the man page for relay-ctrl-chdir will be added!
	doman relay-ctrl-age.8 relay-ctrl-allow.8 relay-ctrl-check.8 relay-ctrl-send.8 relay-ctrl-udp.8
	dodoc README ANNOUNCEMENT NEWS

	keepdir ${RELAYCTRL_BASE} ${RELAYCTRL_BASE}/${RELAYCTRL_STORAGE}
	fperms 700 ${RELAYCTRL_BASE}
	fperms 1777 ${RELAYCTRL_BASE}/${RELAYCTRL_STORAGE}

	dodir ${RELAYCTRL_CONFDIR}

	# tell it our storage dir
	echo "${RELAYCTRL_BASE}/${RELAYCTRL_STORAGE}" > ${D}${RELAYCTRL_CONFDIR}/RELAY_CTRL_DIR
	# default to 30 minutes
	echo "1800" > ${D}${RELAYCTRL_CONFDIR}/RELAY_CTRL_EXPIRY

	echo "/usr/bin/envdir ${RELAYCTRL_CONFDIR} ${RELAYCTRL_BINDIR}/relay-ctrl-age" >${D}/etc/cron.hourly/relay-ctrl-age
	chmod +x ${D}/etc/cron.hourly/relay-ctrl-age
}

pkg_postinst() {
	[ -d /usr/lib/courier-imap/authlib ] && ln -sf /usr/bin/relay-ctrl-allow /usr/lib/courier-imap/authlib/relay-ctrl-allow
	einfo "Please see the instructions in /usr/share/doc/${PF}/README for setup instructions with Courier-IMAP and Qmail"
}
