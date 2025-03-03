# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/latex2rtf/latex2rtf-1.9.19.ebuild,v 1.6 2008/07/09 07:54:49 aballier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="LaTeX to RTF converter"
HOMEPAGE="http://latex2rtf.sourceforge.net/"
SRC_URI="mirror://sourceforge/latex2rtf/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="doc test"

DEPEND="virtual/latex-base
	media-gfx/imagemagick
	doc? ( virtual/texi2dvi )
	test? ( || (
		( dev-texlive/texlive-langgerman dev-texlive/texlive-fontsrecommended )
		app-text/tetex
		app-text/ptex
		)
		dev-tex/latex2html
	)"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	emake PREFIX="/usr" CC=$(tc-getCC) || die "emake failed"
	if use doc; then
		cd "${S}/doc"
		emake clean || die "cleaning docs failed"
		emake || die "generating docs failed"
	fi
}

src_install() {
	dodoc README ChangeLog doc/credits
	emake PREFIX="${D}/usr" MAN_INSTALL="${D}/usr/share/man/man1" SUPPORT_INSTALL="${D}/usr/share/doc/${PF}" install || die "make install failed"
	# if doc is not used, only the text version is intalled.
	if use doc; then
		emake INFO_INSTALL="${D}/usr/share/info" install-info || die "installing info documentation failed"
	fi
}
