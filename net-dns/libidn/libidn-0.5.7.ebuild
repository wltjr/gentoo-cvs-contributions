# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/libidn/libidn-0.5.7.ebuild,v 1.2 2004/10/16 18:30:48 vapier Exp $

DESCRIPTION="Internationalized Domain Names (IDN) implementation."
HOMEPAGE="http://www.gnu.org/software/libidn/"
SRC_URI="ftp://alpha.gnu.org/pub/gnu/libidn/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=""

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog FAQ NEWS README THANKS TODO
}
