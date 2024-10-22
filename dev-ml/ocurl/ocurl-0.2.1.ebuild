# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocurl/ocurl-0.2.1.ebuild,v 1.3 2007/08/12 22:14:44 opfer Exp $

inherit eutils findlib

DESCRIPTION="OCaml interface to the libcurl library"
HOMEPAGE="http://sourceforge.net/projects/ocurl"
LICENSE="MIT"
SRC_URI="mirror://sourceforge/ocurl/${P}.tar.gz"

SLOT="0"
IUSE="doc"

DEPEND=">=net-misc/curl-7.9.8
dev-libs/openssl"
RDEPEND="$DEPEND"
KEYWORDS="~amd64 ppc x86"

src_compile()
{
	econf --with-findlib || die
	emake -j1 all || die
}

src_install()
{
	findlib_src_install
	dodoc COPYING
	use doc && dodoc examples/*.ml
}
