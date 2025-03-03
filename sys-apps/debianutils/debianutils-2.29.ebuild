# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/debianutils/debianutils-2.29.ebuild,v 1.1 2008/06/19 01:09:06 vapier Exp $

inherit eutils flag-o-matic

DESCRIPTION="A selection of tools from Debian"
HOMEPAGE="http://packages.debian.org/unstable/utils/debianutils"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="kernel_linux static"

PDEPEND="|| ( >=sys-apps/coreutils-6.10-r1 sys-apps/mktemp sys-freebsd/freebsd-ubin )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.28.2-no-bs-namespace.patch
	epatch "${FILESDIR}"/${PN}-2.28.2-mkboot-quiet.patch
	epatch "${FILESDIR}"/${PN}-2.16.2-palo.patch
}

src_compile() {
	use static && append-ldflags -static
	econf || die
	emake || die
}

src_install() {
	into /
	dobin tempfile run-parts || die
	if use kernel_linux ; then
		dosbin installkernel || die "installkernel failed"
	fi

	into /usr
	dosbin savelog || die "savelog failed"
	if use kernel_linux ; then
		dosbin mkboot || die "mkboot failed"
	fi

	doman tempfile.1 run-parts.8 savelog.8
	use kernel_linux && doman installkernel.8 mkboot.8
	cd debian
	dodoc changelog control
}
