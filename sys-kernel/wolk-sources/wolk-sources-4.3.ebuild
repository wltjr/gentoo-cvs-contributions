# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/wolk-sources/wolk-sources-4.3.ebuild,v 1.11 2003/12/02 04:19:13 iggy Exp $

IUSE="build"

ETYPE="sources"
inherit kernel

# OKV=original kernel version, KV=patched kernel version.  They can be the same.

OKV=2.4.20
EXTRAVERSION=-wolk4.3s
BASE=-wolk4.0s
KV=${OKV}${EXTRAVERSION}
S=${WORKDIR}/linux-${KV}

DESCRIPTION="Working Overloaded Linux Kernel"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
		mirror://sourceforge/wolk/linux-${OKV}${BASE}.patch.bz2
		mirror://sourceforge/wolk/linux-${OKV}-wolk4.0s-to-4.1s.patch.bz2
		mirror://sourceforge/wolk/linux-${OKV}-wolk4.1s-to-4.2s.patch.bz2
		mirror://sourceforge/wolk/linux-${OKV}-wolk4.2s-to-4.3s.patch.bz2"
KEYWORDS="x86"
SLOT="${KV}"
HOMEPAGE="http://wolk.sourceforge.net http://www.kernel.org"

src_unpack() {
	unpack linux-${OKV}.tar.bz2
	mv linux-${OKV} linux-${KV} || die
	cd ${WORKDIR}/linux-${KV}
	bzcat ${DISTDIR}/linux-${OKV}${BASE}.patch.bz2 | patch -p1 || die
	bzcat ${DISTDIR}/linux-${OKV}-wolk4.0s-to-4.1s.patch.bz2 | patch -p1 || die
	bzcat ${DISTDIR}/linux-${OKV}-wolk4.1s-to-4.2s.patch.bz2 | patch -p1 || die
	bzcat ${DISTDIR}/linux-${OKV}-wolk4.2s-to-4.3s.patch.bz2 | patch -p1 || die
	epatch ${FILESDIR}/do_brk_fix.patch || die "failed to patch for do_brk vuln"
}
src_install() {
	dodir /usr/src
	echo ">>> Copying sources..."
	dodoc ${FILESDIR}/patches.txt
	mv ${WORKDIR}/linux* ${D}/usr/src
}

pkg_postinst() {
	einfo
	einfo   "If you use one of the NVIDIA modules below, you will need to use the"
	einfo   "supplied rmap patch in /usr/src/linux-2.4.20-wolk4.3s/userspace-patches"
	einfo   "against your nvidia kernel driver source"
	einfo   "cd NVIDIA_kernel-1.0-XXXX "
	einfo	"patch -p1 </usr/src/linux-2.4.20-wolk4.3s/userspace-patches/"
	einfo   "NVIDIA_kernel-1.0-XXXX-2.4-rmap15b.patch"
	einfo   "There are NVIDIA_kernel-1.0-3123 and 1.0-4191 patches supplied."
	einfo
}

