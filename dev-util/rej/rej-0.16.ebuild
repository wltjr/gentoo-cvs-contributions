# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rej/rej-0.16.ebuild,v 1.4 2006/01/24 10:29:58 dsd Exp $

DESCRIPTION="A utility for solving diff/patch rejects"
HOMEPAGE="http://ftp.suse.com/pub/people/mason/rej/"
SRC_URI="http://ftp.suse.com/pub/people/mason/rej/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl"

src_compile() {
	echo
}

src_install() {
	dobin rej qp mp
	dodoc CHANGELOG README vimrc
}
