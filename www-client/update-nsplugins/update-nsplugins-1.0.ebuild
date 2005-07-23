# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/update-nsplugins/update-nsplugins-1.0.ebuild,v 1.2 2005/07/23 09:19:58 azarah Exp $

inherit nsplugins

DESCRIPTION="Updates plugin symlinks for browsers using Netscape compatible plugins"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=

DEPEND=
RDEPEND=

src_install() {
	newsbin ${FILESDIR}/${P} ${PN}

	dodir /etc
	cat > ${D}/etc/nsplugins.conf <<-EOF
		NSPLUGINS_DIR="${NSPLUGINS_DIR}"
		NSBROWSERS_DIR="${NSBROWSERS_DIR}"
	EOF
}
