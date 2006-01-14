# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xinit/xinit-1.0.1.ebuild,v 1.6 2006/01/14 20:38:13 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
# This is enabled due to modified Makefile.am from the patches
SNAPSHOT="yes"

inherit x-modular pam

DESCRIPTION="X.Org xinit application"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~s390 ~sh ~sparc ~x86"
RDEPEND="x11-libs/libX11
		x11-wm/twm
		x11-apps/xclock
		x11-apps/xrdb
		x11-terms/xterm"
DEPEND="${RDEPEND}"
LICENSE="${LICENSE} GPL-2"

PATCHES="${FILESDIR}/nolisten-tcp-and-black-background.patch
	${FILESDIR}/gentoo-startx-customization-0.99.4.patch"

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
	newinitd ${FILESDIR}/xdm.start xdm
	newpamd ${FILESDIR}/xserver.pamd xserver
}
