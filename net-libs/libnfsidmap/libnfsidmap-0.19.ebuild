# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnfsidmap/libnfsidmap-0.19.ebuild,v 1.1 2007/01/21 00:13:40 vapier Exp $

DESCRIPTION="NFSv4 ID <-> name mapping library"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux/"
SRC_URI="http://www.citi.umich.edu/projects/nfsv4/linux/libnfsidmap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="ldap"

DEPEND="ldap? ( net-nds/openldap )"
RDEPEND="${DEPEND}
	!net-fs/idmapd"

src_compile() {
	econf $(use_enable ldap) || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
