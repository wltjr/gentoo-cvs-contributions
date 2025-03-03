# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ibm-powerpc-utils-papr/ibm-powerpc-utils-papr-1.0.4.ebuild,v 1.3 2008/04/21 20:17:41 ranger Exp $

inherit eutils

MY_P="powerpc-utils-papr-${PV}"

DESCRIPTION="This package provides the utilities which are intended for the maintenance of IBM powerpc platforms."
SRC_URI="http://powerpc-utils.ozlabs.org/releases/powerpc-utils-papr-${PV}.tar.gz"
HOMEPAGE="http://powerpc-utils.ozlabs.org/"

S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="IPL-1"
KEYWORDS="ppc ppc64"
IUSE=""
RDEPEND=">=sys-apps/ibm-powerpc-utils-1.0.4
	sys-libs/librtas
	virtual/logger"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/ibm-powerpc-utils-papr-1.0.4-remove-doc.patch
	epatch "${FILESDIR}"/ibm-powerpc-utils-papr-1.0.4-removeinitandvscsis.patch
}

src_install() {
	make DESTDIR="${D}" install || die "Compilation failed"
	dodoc README COPYRIGHT
	#dodir /etc/init.d
	#exeinto /etc/init.d
	#newexe ${FILESDIR}/ibmvscsis ibmvscsis
}

pkg_postinst() {
	#einfo "An initscript for managing virtual scsi servers has "
	#einfo "been install into /etc/init.d/ called ibmviscsis. "
	#einfo "Before you can use this daemon, you must create a proper "
	#einfo "/etc/ibmvscsis.conf file."
	einfo "Support for the IBM Virtual SCSI server (virtual disk) "
	einfo "is not included in this version of powerpc-utils-papr. "
	einfo "When the ibmvscsis function is generally available in  "
	einfo "the kernel source trees, it will be added back in."
}
