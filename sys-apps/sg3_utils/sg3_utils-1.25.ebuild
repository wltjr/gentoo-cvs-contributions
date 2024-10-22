# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sg3_utils/sg3_utils-1.25.ebuild,v 1.9 2008/03/22 22:50:33 coldwind Exp $

inherit eutils

DESCRIPTION="Apps for querying the sg SCSI interface"
HOMEPAGE="http://www.torque.net/sg/"
SRC_URI="http://www.torque.net/sg/p/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""
DEPEND="sys-devel/libtool"
RDEPEND="sys-apps/sdparm"
PDEPEND=">=sys-apps/rescan-scsi-bus-1.24"

src_install() {
	dodoc ChangeLog AUTHORS COVERAGE CREDITS README*
	dodoc doc/README.doc examples/*.txt
	newdoc scripts/README README.scripts
	make install DESTDIR="${D}" || die "make install failed"
	dosbin scripts/{scsi,sas}*
}
