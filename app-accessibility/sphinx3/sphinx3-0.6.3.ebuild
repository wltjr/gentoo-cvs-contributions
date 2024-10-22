# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/sphinx3/sphinx3-0.6.3.ebuild,v 1.2 2006/09/30 19:43:02 vapier Exp $

DESCRIPTION="CMU Speech Recognition engine"
HOMEPAGE="http://fife.speech.cs.cmu.edu/sphinx/"
SRC_URI="mirror://sourceforge/cmusphinx/${P}.tar.gz"

LICENSE="BSD as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${PV:0:3}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
	cd doc
	dohtml -r -x CVS s3* s3 *.html
}
