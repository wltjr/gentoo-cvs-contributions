# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xml2doc/xml2doc-20030510.ebuild,v 1.13 2006/01/22 18:15:31 genone Exp $

IUSE="pdf"

S=${WORKDIR}/${PN}
DESCRIPTION="An XML processor tool that allows for converting documents written in simple XML to a variety of document formats (eg pdf,html,txt,manpage)"
HOMEPAGE="http://xml2doc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ppc sparc alpha ~hppa ~mips amd64 ia64 ppc64"

DEPEND=">=dev-libs/libxml2-2.5
	pdf? ( >=media-libs/pdflib-4 )"

src_compile() {
	econf `use_enable pdf` || die
	emake || die
}

src_install() {
	# xml2doc's make install is unfortunately broken
	# binary
	dobin ${S}/src/xml2doc
	# documentation
	dodoc BUGS README TODO
	docinto examples
	dodoc ${S}/examples/*.{xml,png}
	# manpage
	cd ${S}/doc
	${S}/src/xml2doc -oM manpage.xml xml2doc.1
	doman xml2doc.1
}
