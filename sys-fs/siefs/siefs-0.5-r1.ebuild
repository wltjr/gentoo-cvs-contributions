# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/siefs/siefs-0.5-r1.ebuild,v 1.1 2007/05/23 11:17:20 mrness Exp $

inherit eutils

DESCRIPTION="Siemens FS"
HOMEPAGE="http://chaos.allsiemens.com/siefs"
SRC_URI="http://chaos.allsiemens.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="sys-fs/fuse"

src_unpack() {
	unpack ${A}

	cd "${S}/siefs"
	epatch "${FILESDIR}"/${P}-qa-fixes.patch

	sed -i "s:-rm -f /sbin/mount.siefs:-mkdir \$(DESTDIR)/sbin/:" Makefile.in
	sed -i "s:-ln -s \$(DESTDIR)\$(bindir)/siefs /sbin/mount.siefs:-ln -s ..\$(bindir)/siefs \$(DESTDIR)/sbin/mount.siefs:" Makefile.in
	sed -i "s:LDADD = \$(fuseinst)/lib/libfuse.a:LDADD = -lfuse:" Makefile.in
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README AUTHORS
}
