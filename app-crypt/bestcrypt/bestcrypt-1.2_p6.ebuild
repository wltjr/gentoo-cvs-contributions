# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bestcrypt/bestcrypt-1.2_p6.ebuild,v 1.4 2003/11/12 14:14:30 vapier Exp $

MY_PN="bcrypt"
DESCRIPTION="commercially licensed transparent filesystem encryption"
HOMEPAGE="http://www.jetico.com/"
SRC_URI="http://www.jetico.com/linux/BestCrypt-${PV/_p/-}.tar.gz
	http://www.jetico.com/linux/BestCrypt.doc.tgz"

LICENSE="bestcrypt"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/linux-sources"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	unpack ${A}
	for file in `find . -type f -iname Makefile*`;do
		sed -i -e "s:-O[0-9]:${CFLAGS}:"	\
		    -e 's%KVER =.*%KVER = $(shell readlink /usr/src/linux|sed -e "s:linux-\\([0-9]\\+\.[0-9]\\+\\)\..*:\\1:")%' \
		    -e "s%uname -r%readlink /usr/src/linux|sed -e 's:linux-::'%" \
			 ${file}

	done
}

src_compile() {
	emake -j1 || die
}

src_install() {
	#Install docs
	dohtml ${WORKDIR}/bchelp/*
	dodir /usr/share/doc/bestcrypt-1.2_p5/html/img
	insinto /usr/share/doc/bestcrypt-1.2_p5/html/img
	doins ${WORKDIR}/bchelp/img/*

	exeinto /etc/rc.d/init.d
	doexe ${FILESDIR}/bcrypt
	dodir \
		/usr/bin \
		/etc/init.d \
		/etc/rc.d/rc{0,1,2,3,4,5,6}.d \
		/etc/rc{0,1,2,3,4,5,6}.d \
		/usr/share/man/man8 \
		/lib/modules/${KV}/kernel/drivers/block
	einstall MAN_PATH="/usr/share/man" \
		 root="${D}" \
		 MOD_PATH=/lib/modules/${KV}/kernel/drivers/block
	exeinto /etc/init.d
	doexe ${FILESDIR}/bcrypt
	rm -rf ${D}/etc/rc*.d
	dodoc README LICENSE
}
