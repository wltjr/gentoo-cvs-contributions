# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sysrqd/sysrqd-9.ebuild,v 1.2 2007/04/30 20:03:39 genone Exp $

inherit eutils toolchain-funcs

IUSE=""
DESCRIPTION="daemon providing access to the kernel sysrq functions via network"
HOMEPAGE="http://julien.danjou.info/sysrqd.html"
SRC_URI="http://julien.danjou.info/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-config.patch
}

src_compile() {
	$(tc-getCC) ${CFLAGS} -o sysrqd sysrqd.c
}

src_install() {

	dosbin sysrqd
	newinitd ${FILESDIR}/sysrqd.init sysrqd

	local bindip='127.0.0.1' secret
	declare -i secret
	let secret=${RANDOM}*${RANDOM}*${RANDOM}*${RANDOM}
	echo ${bindip} > sysrqd.bind
	echo ${secret} > sysrqd.secret

	diropts -m 0700 -o root -g root
	dodir /etc/sysrqd
	insinto /etc/sysrqd
	insopts -m 0600 -o root -g root
	doins sysrqd.bind
	doins sysrqd.secret

	dodoc README ChangeLog
}

pkg_postinst() {
	elog
	elog "Be sure to change the initial secret in /etc/sysrqd/sysrqd.secret !"
	elog "As a security precaution, sysrqd is configured to only listen on"
	elog "127.0.0.1 by default. Change the content of /etc/sysrqd/sysrqd.bind"
	elog "to an IPv4 address you want it to listen on or remove the file"
	elog "to make it listen on any IP address (0.0.0.0)."
	elog
}
