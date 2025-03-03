# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/wxmaxima/wxmaxima-0.7.3a.ebuild,v 1.7 2008/02/26 17:34:25 bicatali Exp $

WX_GTK_VER="2.6"
inherit eutils autotools wxwidgets fdo-mime

MYP=wxMaxima-${PV}

DESCRIPTION="Graphical frontend to Maxima, using the wxWidgets toolkit."
HOMEPAGE="http://wxmaxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="unicode"

DEPEND=">=dev-libs/libxml2-2.5.0
	=x11-libs/wxGTK-2.6*"
RDEPEND="${DEPEND}
	>=sci-mathematics/maxima-5.13.0"

S="${WORKDIR}/${MYP}"

pkg_setup() {
	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets ansi
	fi
}

src_compile () {

	# consistent package names
	sed -i \
		-e "s:${datadir}/wxMaxima:${datadir}/${PN}:g" \
		Makefile.in data/Makefile.in || die "sed failed"

	sed -i \
		-e 's:share/wxMaxima:share/wxmaxima:g' \
		src/wxMaxima.cpp || die "sed failed"

	econf \
		--enable-dnd \
		--enable-printing \
		--with-wx-config=${WX_CONFIG} \
		$(use_unicode unicode-glyphs) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon maxima-new.png wxmaxima.png
	make_desktop_entry wxmaxima wxMaxima wxmaxima
	dodir /usr/share/doc/${PF}
	dosym /usr/share/${PN}/README /usr/share/doc/${PF}/README
	dodoc AUTHORS
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
