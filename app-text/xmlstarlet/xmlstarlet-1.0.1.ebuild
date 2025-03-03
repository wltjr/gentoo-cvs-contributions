# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xmlstarlet/xmlstarlet-1.0.1.ebuild,v 1.6 2007/03/14 07:26:38 leonardop Exp $

inherit flag-o-matic

DESCRIPTION="set of XML command line utilities"
HOMEPAGE="http://xmlstar.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmlstar/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND=">=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.9
	dev-libs/libgcrypt
	dev-libs/libgpg-error"

src_compile() {
	append-ldflags -lgcrypt
	local xsltlibs="-lxslt -lexslt"
	local xmllibs="-lxml2"
	LIBXSLT_LIBS="${xsltlibs}" LIBXML_LIBS="${xmllibs}" econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml -r *
}

src_test() {
	cd tests
	sh runTests || die "sh runTests failed."
}
