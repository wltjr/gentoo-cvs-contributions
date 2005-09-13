# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/apmd/apmd-3.2.1_p4.ebuild,v 1.14 2005/09/13 21:05:13 dang Exp $

inherit eutils multilib

MY_PV="${PV%_p*}"
MY_P="${PN}_${MY_PV}"
PATCHV="${PV#*_p}"

S="${WORKDIR}/${PN}-${MY_PV}.orig"
DESCRIPTION="Advanced Power Management Daemon"
HOMEPAGE="http://www.worldvisions.ca/~apenwarr/apmd/"
SRC_URI="mirror://debian/pool/main/a/apmd/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/apmd/${MY_P}-${PATCHV}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 x86"
IUSE="X nls"

RDEPEND=">=sys-apps/debianutils-1.16
	X? ( virtual/x11 )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	virtual/os-headers"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${MY_P}-${PATCHV}.diff

	if ! use X ; then
		sed -e 's:\(EXES=.*\)xapm:\1:' \
			-e 's:\(.*\)\$(LT_INSTALL).*xapm.*$:\1echo:' \
			-i ${S}/Makefile
	fi
}

src_compile() {
	emake || die
}

src_install() {
	dodir /usr/sbin

	make DESTDIR=${D} PREFIX=/usr LIBDIR=/usr/$(get_libdir) install || die "install failed"

	dodir /etc/apm/{event.d,suspend.d,resume.d,other.d,scripts.d}
	exeinto /etc/apm ; doexe debian/apmd_proxy
	dodoc AUTHORS apmsleep.README README debian/README.Debian
	dodoc debian/changelog* debian/copyright*

	doman *.1 *.8

	# note: apmd_proxy.conf is currently disabled and not used, thus
	#       not installed - liquidx (01 Mar 2004)

	insinto /etc/conf.d ; newins ${FILESDIR}/apmd.confd apmd
	exeinto /etc/init.d ; newexe ${FILESDIR}/apmd.rc6 apmd

	use nls || rm -rf ${D}/usr/share/man/fr
}
