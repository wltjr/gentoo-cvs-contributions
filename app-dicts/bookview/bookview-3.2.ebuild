# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/bookview/bookview-3.2.ebuild,v 1.3 2004/05/31 18:24:58 vapier Exp $

inherit eutils

DESCRIPTION="NDTP client written in Tcl/Tk"
HOMEPAGE="http://www.sra.co.jp/people/m-kasahr/bookview/"
SRC_URI="ftp://ftp.sra.co.jp/pub/net/ndtp/bookview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="cjk"

DEPEND=">=sys-apps/sed-4"
RDEPEND=">=dev-lang/tk-8.3"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {
	econf `use_enable cjk ja-doc` || die
	emake || die
}

src_install() {
	einstall || die

	insinto /etc/X11/app-defaults
	newins ${FILESDIR}/Bookview.ad Bookview

	dodoc AUTHORS ChangeLog* INSTALL NEWS README
	use cjk && dodoc INSTALL-ja README-ja
}
