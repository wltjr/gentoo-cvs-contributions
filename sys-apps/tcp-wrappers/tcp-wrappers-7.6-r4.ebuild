# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tcp-wrappers/tcp-wrappers-7.6-r4.ebuild,v 1.18 2003/02/22 02:18:35 zwelch Exp $

inherit eutils

MY_P=${P//-/_}

S=${WORKDIR}/${MY_P}
DESCRIPTION="TCP Wrappers"
SRC_URI="ftp://ftp.porcupine.org/pub/security/${MY_P}.tar.gz
	mirror://gentoo/${PF}-gentoo.tar.bz2"
HOMEPAGE="ftp://ftp.porcupine.org/pub/security/index.html"

SLOT="0"
LICENSE="freedist"
KEYWORDS="x86 ppc sparc alpha mips hppa arm"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}

	PATCHDIR=${WORKDIR}/${PV}-patches

	cd ${S}
	epatch ${PATCHDIR}/${MY_P}-ipv6-1.6.diff
	epatch ${PATCHDIR}/${MY_P}-stdc.diff
	epatch ${PATCHDIR}/${MY_P}.diff
	
	cp Makefile Makefile.orig
	sed -e "s:-O2:${CFLAGS} -fPIC:" \
		-e "s:AUX_OBJ=.*:AUX_OBJ= \\\:" Makefile.orig > Makefile

}

src_compile() {
	make ${MAKEOPTS} \
		REAL_DAEMON_DIR=/usr/sbin \
		linux || die
}

src_install() {
	dosbin tcpd tcpdchk tcpdmatch safe_finger try-from
	doman *.[358]
	dosym hosts_access.5.gz /usr/share/man/man5/hosts.allow.5.gz
	dosym hosts_access.5.gz /usr/share/man/man5/hosts.deny.5.gz
	dolib.a libwrap.a
	insinto /usr/include
	doins tcpd.h

	dodoc BLURB CHANGES DISCLAIMER README*
}
