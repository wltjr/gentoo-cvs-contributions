# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/fityk/fityk-0.8.6.ebuild,v 1.2 2008/07/13 17:39:33 bicatali Exp $

EAPI="1"
WX_GTK_VER="2.8"

inherit wxwidgets flag-o-matic

DESCRIPTION="General-purpose nonlinear curve fitting and data analysis"
HOMEPAGE="http://www.unipress.waw.pl/fityk/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gnuplot readline wxwindows"

CDEPEND="sci-libs/xylib
	readline? ( sys-libs/readline )
	wxwindows? ( x11-libs/wxGTK:2.8 )"

DEPEND="${CDEPEND}"
# removing temporarly external boost (see bug #231177)
#	dev-libs/boost"

RDEPEND="${CDEPEND}
	gnuplot? ( sci-visualization/gnuplot )"

src_compile() {
	# temporary, see above
	append-cppflags -I../3rdparty

	econf  \
		--disable-3rdparty \
		$(use_enable wxwindows GUI) \
		$(use_with doc) \
		$(use_with readline) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README TODO || die
	rm -f samples/Makefile*
	insinto /usr/share/doc/${PF}
	use examples && doins -r samples
}
