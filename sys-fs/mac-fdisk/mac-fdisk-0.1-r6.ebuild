# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mac-fdisk/mac-fdisk-0.1-r6.ebuild,v 1.9 2007/06/25 15:58:51 josejx Exp $

inherit eutils toolchain-funcs

DEBRV=13
DESCRIPTION="Mac/PowerMac disk partitioning utility"
HOMEPAGE="ftp://ftp.mklinux.apple.com/pub/Other_Tools/"
SRC_URI="mirror://debian/pool/main/m/mac-fdisk/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/m/mac-fdisk/${PN}_${PV}-${DEBRV}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack mac-fdisk_${PV}.orig.tar.gz
	mv mac-fdisk-${PV}.orig ${P}
	cd "${S}"
	epatch "${DISTDIR}"/${PN}_${PV}-${DEBRV}.diff.gz

	epatch "${FILESDIR}"/largerthan2gb.patch
	epatch "${FILESDIR}"/${P}-headers.patch

	### Patch for bug #142737
	epatch ${FILESDIR}/${PN}-0.1-r6-ppc64.patch

	### Patch for building on amd64
	epatch ${FILESDIR}/${PN}-amd64.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed!"
}

src_install() {
	into /
	newsbin pdisk mac-fdisk || die
	newsbin fdisk pmac-fdisk || die

	into /usr
	newman mac-fdisk.8.in mac-fdisk.8
	newman pmac-fdisk.8.in pmac-fdisk.8
	dodoc README HISTORY
}
