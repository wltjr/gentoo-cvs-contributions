# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/psemu-padjoy/psemu-padjoy-0.62.ebuild,v 1.5 2003/02/13 07:15:56 vapier Exp $

DESCRIPTION="PSEmu plugin to use joysticks/gamepads in PSX-emulators"
HOMEPAGE="http://www.ammoq.com"
LICENSE="GPL-2" # No mention of a license.. That makes it Public Domain?
KEYWORDS="x86 -ppc"
SLOT="0"
DEPEND="x11-libs/gtk+"
SRC_URI="http://members.chello.at/erich.kitzmueller/ammoq/padJoy062.tgz"
S=${WORKDIR}/padJoy
IUSE=""

src_compile() {
	cd src
	( echo CFLAGS = ${CFLAGS}
	  sed 's/CFLAGS =/CFLAGS +=/' < Makefile ) >Makefile.gentoo
	emake -f Makefile.gentoo
}

src_install () {
	insinto /usr/lib/psemu/plugins
	doins src/libpad*
	chmod 755 ${D}/usr/lib/psemu/plugins/*
	dodoc readme.txt
}

