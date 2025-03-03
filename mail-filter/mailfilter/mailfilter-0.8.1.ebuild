# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/mailfilter/mailfilter-0.8.1.ebuild,v 1.2 2008/05/31 10:27:03 tove Exp $

inherit eutils

DESCRIPTION="Mailfilter is a utility to get rid of unwanted spam mails"
HOMEPAGE="http://mailfilter.sourceforge.net/"
SRC_URI="mirror://sourceforge/mailfilter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="sys-devel/flex"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gcc43.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc INSTALL doc/FAQ "${FILESDIR}"/rcfile.example{1,2} \
		README THANKS ChangeLog AUTHORS NEWS || die "doc failed"
}
