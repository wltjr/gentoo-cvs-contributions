# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pakchois/pakchois-0.4.ebuild,v 1.6 2008/06/14 16:31:57 nixnut Exp $

DESCRIPTION="PaKChoiS - PKCS #11 wrapper library"
HOMEPAGE="http://www.manyfish.co.uk/pakchois/"
SRC_URI="http://www.manyfish.co.uk/pakchois/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README
}
