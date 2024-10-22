# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/checkpassword-pam/checkpassword-pam-0.97.ebuild,v 1.6 2004/12/13 23:39:08 ticho Exp $

IUSE=""

DESCRIPTION="checkpassword-compatible authentication program w/pam support"
HOMEPAGE="http://checkpasswd-pam.sourceforge.net/"
SRC_URI="mirror://sourceforge/checkpasswd-pam/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND=">=sys-libs/pam-0.75
	virtual/libc"

src_install() {
	einstall || die
	dodoc AUTHORS NEWS README
}
