# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/m17n-db/m17n-db-1.3.4.ebuild,v 1.1 2006/12/24 05:28:07 matsuu Exp $

DESCRIPTION="Database for the m17n library"
HOMEPAGE="http://www.m17n.org/m17n-lib/"
SRC_URI="http://www.m17n.org/m17n-lib-download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

IUSE=""

DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README
	docinto FORMATS; dodoc FORMATS/*
	docinto UNIDATA; dodoc UNIDATA/*
}
