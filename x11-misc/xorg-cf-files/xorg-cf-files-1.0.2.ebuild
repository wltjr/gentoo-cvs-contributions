# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xorg-cf-files/xorg-cf-files-1.0.2.ebuild,v 1.9 2007/02/20 00:07:12 blubb Exp $

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Old Imake-related build files"

KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

RDEPEND=""
DEPEND=""

src_install() {
	x-modular_src_install
	echo "#define ManDirectoryRoot /usr/share/man" >> ${D}/usr/$(get_libdir)/X11/config/host.def
	sed -i -e "s/LibDirName *lib$/LibDirName $(get_libdir)/" ${D}/usr/$(get_libdir)/X11/config/Imake.tmpl || die "failed libdir sed"
}
