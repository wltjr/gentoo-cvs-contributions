# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/rescan-scsi-bus/rescan-scsi-bus-1.25-r1.ebuild,v 1.7 2008/03/22 22:50:11 coldwind Exp $

inherit eutils

DESCRIPTION="Script to rescan the SCSI bus without rebooting"
HOMEPAGE="http://www.garloff.de/kurt/linux/"
SCRIPT_NAME="${PN}.sh"
SRC_NAME="${SCRIPT_NAME}-${PV}"
SRC_URI="http://www.garloff.de/kurt/linux/${SRC_NAME}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/sg3_utils-1.24
		 sys-apps/module-init-tools
		 app-shells/bash"

S="${WORKDIR}"

src_unpack() {
	einfo "Unpacking into ${WORKDIR}/"
	cp -f "${DISTDIR}"/${SRC_NAME} "${WORKDIR}"/${SCRIPT_NAME}
	epatch "${FILESDIR}"/${P}-support-sysfs-only-systems.patch
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	into /usr
	dosbin ${SCRIPT_NAME}
	# Some scripts look for this without the trailing .sh
	# Some look for it with the trailing .sh, so have a symlink
	dosym ${SCRIPT_NAME} /usr/sbin/${PN}
}
