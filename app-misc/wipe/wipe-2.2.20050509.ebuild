# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/wipe/wipe-2.2.20050509.ebuild,v 1.6 2007/12/07 17:00:29 dertobi123 Exp $

inherit versionator

MY_PV=$(get_version_component_range 3)
MY_SRC=${PN}-wip-${MY_PV}
S="${WORKDIR}/${PN}"

DESCRIPTION="Secure file wiping utility based on Peter Gutman's patterns"
HOMEPAGE="http://wipe.sourceforge.net/"
SRC_URI="mirror://sourceforge/wipe/${MY_SRC}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND=""

src_install() {
	dobin wipe || die "dobin failed"
	doman wipe.1
	dodoc CHANGES README TODO TESTING
}

pkg_postinst() {
	elog "Note that wipe is useless on journalling filesystems, such as reiserfs or XFS."
	elog "See documentation for more info."
}
