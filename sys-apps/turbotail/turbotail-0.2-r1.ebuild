# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/turbotail/turbotail-0.2-r1.ebuild,v 1.3 2008/05/25 18:34:24 jer Exp $

inherit eutils

DESCRIPTION="drop-in replacement for 'tail' which uses the kernel DNOTIFY-api"
HOMEPAGE="http://www.vanheusden.com/turbotail/"
SRC_URI="http://www.vanheusden.com/Linux/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# apply munmap patch (see bug #101694)
	epatch "${FILESDIR}/${P}-munmap.patch"
}

src_compile() {
	# enforce our CFLAGS
	emake CFLAGS="-Wall ${CFLAGS} -DVERSION=\"${VERSION}\"" || die "emake failed"
}

src_install() {
	dobin turbotail || die "install failed"
	dodoc readme.txt
}
