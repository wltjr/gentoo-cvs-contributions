# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/ipvsadm/ipvsadm-1.21-r1.ebuild,v 1.8 2005/01/21 18:14:37 xmerlin Exp $

inherit check-kernel

DESCRIPTION="ipvsadm is a utility to administer the IP virtual server services offered by the Linux kernel with IP virtual server support."
HOMEPAGE="http://linuxvirtualserver.org"
LICENSE="GPL-2"
DEPEND="virtual/libc
	virtual/linux-sources
	>=sys-libs/ncurses-5.2"

SRC_URI="http://www.linuxvirtualserver.org/software/kernel-2.4/${P}.tar.gz"

SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

pkg_setup() {
	if is_2_5_kernel || is_2_6_kernel
	then
		die "${P} does not support 2.5 and 2.6 kernels, please try ${PN}-1.24"
	fi
}


src_compile() {
	check_KV
	make || die "error compiling source"
}

src_install() {
	into /
	dosbin ipvsadm ipvsadm-save ipvsadm-restore || die

	doman ipvsadm.8 ipvsadm-save.8 ipvsadm-restore.8

	exeinto /etc/init.d
	newexe ${FILESDIR}/ipvsadm-init ipvsadm || die
	keepdir /var/lib/ipvsadm

	diropts -m 755 -o root -g root
	dodir /usr/lib
	dodir /usr/include/ipvs

	insopts -m 644 -o root -g root
	insinto /usr/lib
	doins libipvs/libipvs.a || die

	insinto /usr/include/ipvs
	newins libipvs/libipvs.h ipvs.h || die

	einfo "You will need a kernel that has ipvs patches to use LVS"
}
