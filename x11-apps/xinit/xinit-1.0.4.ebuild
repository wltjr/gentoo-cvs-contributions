# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xinit/xinit-1.0.4.ebuild,v 1.9 2008/04/09 02:08:44 dirtyepic Exp $

# Must be before x-modular eclass is inherited
# This is enabled due to modified Makefile.am from the patches
SNAPSHOT="yes"

inherit x-modular pam

DESCRIPTION="X Window System initializer"

LICENSE="${LICENSE} GPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="minimal"

RDEPEND="x11-apps/xauth
	x11-libs/libX11"
DEPEND="${RDEPEND}"
PDEPEND="!minimal? ( x11-wm/twm
				x11-apps/xclock
				x11-apps/xrdb
				x11-apps/xsm
				x11-terms/xterm )"

PATCHES="${FILESDIR}/nolisten-tcp-and-black-background.patch
	${FILESDIR}/gentoo-startx-customization-${PV}.patch"

src_unpack() {
	x-modular_unpack_source
	x-modular_patch_source

	sed -i -e "s:^XINITDIR.*:XINITDIR = \$(sysconfdir)/X11/xinit:g" ${S}/Makefile.am

	x-modular_reconf_source
}

src_install() {
	x-modular_src_install
	exeinto /etc/X11
	doexe ${FILESDIR}/chooser.sh ${FILESDIR}/startDM.sh
	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/Xsession
	exeinto /etc/X11/xinit
	doexe ${FILESDIR}/xinitrc
	newinitd ${FILESDIR}/xdm.initd-1 xdm
	newconfd ${FILESDIR}/xdm.confd-1 xdm
	newpamd ${FILESDIR}/xserver.pamd xserver
}
