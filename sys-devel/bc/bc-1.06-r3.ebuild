# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/bc/bc-1.06-r3.ebuild,v 1.1 2001/11/04 07:44:50 woodchip Exp $
      
DESCRIPTION="Handy console-based calculator utility"
HOMEPAGE="http://www.gnu.org/software/bc/bc.html"
S=${WORKDIR}/${P}
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/bc/${P}.tar.gz
	ftp://prep.ai.mit.edu/pub/gnu/bc/${P}.tar.gz"

RDEPEND="virtual/glibc readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )"
DEPEND="$RDEPEND sys-devel/flex"

src_unpack() {

	unpack ${A} ; cd ${S}
	patch -p1 < ${FILESDIR}/bc-1.06-info-fix.diff || die
	patch -p1 < ${FILESDIR}/bc-1.06-readline42.diff || die
}

src_compile() {

	local myconf
	use readline && myconf="--with-readline"
	./configure ${myconf} --host=${CHOST} --prefix=/usr || die
	emake || die
}

src_install() {

	into /usr
	doinfo doc/*.info
	dobin bc/bc dc/dc
	doman doc/*.1
	dodoc AUTHORS COPYING* FAQ NEWS README ChangeLog
}
