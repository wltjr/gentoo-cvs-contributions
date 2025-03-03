# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/cowloop/cowloop-3.0-r2.ebuild,v 1.3 2008/04/01 14:39:22 dragonheart Exp $

inherit linux-mod toolchain-funcs

DESCRIPTION="A copy-on-write loop driver (block device) to be used on top of any other block driver"
HOMEPAGE="http://www.atconsultancy.nl/cowloop/"
SRC_URI="http://www.atconsultancy.nl/cowloop/packages/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~ppc x86 ~amd64"
IUSE=""
DEPEND="virtual/libc
	virtual/linux-sources"

S=${WORKDIR}/${P}/src
MODULE_NAMES="cowloop(fs:)"
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S} -I."
	einfo "Linux kernel ${KV_FULL}"
	if kernel_is lt 2 6
	then
		eerror "This version only works with 2.6 kernels"
		die "No compatible kernel detected!"
	fi
}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-cflags.patch
	epatch "${FILESDIR}"/${P}-config_h.patch
	epatch "${FILESDIR}"/${P}-vfs_statfs.patch
}

src_compile() {
	touch .gpl_license_accepted
	linux-mod_src_compile
	CC="$(tc-getCC)" emake utils || die "make failed"
}

src_install() {
	linux-mod_src_install
	emake DESTDIR="${D}" install-utils install-man || die 'make failed'
	dodoc "${S}"/../RELEASENOTES "${S}"/../HOWTO ../doc/*
	dodir /etc/udev/rules.d
	echo 'KERNEL=="cowctl"        NAME="cow/ctl"' > "${D}"/etc/udev/rules.d/70-cow.rules
	echo 'KERNEL=="cow[0-9]*"  NAME="cow/%n"' >> "${D}"/etc/udev/rules.d/70-cow.rules
}
