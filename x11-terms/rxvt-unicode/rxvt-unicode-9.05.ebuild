# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt-unicode/rxvt-unicode-9.05.ebuild,v 1.1 2008/06/21 18:18:07 killerfox Exp $

inherit flag-o-matic

DESCRIPTION="rxvt clone with XFT and Unicode support"
HOMEPAGE="http://software.schmorp.de/"
SRC_URI="http://dist.schmorp.de/rxvt-unicode/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="truetype perl iso14755 afterimage"

# see bug #115992 for modular x deps
RDEPEND="x11-libs/libX11
	x11-libs/libXft
	afterimage? ( media-libs/libafterimage )
	x11-libs/libXrender
	perl? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	local tdir=/usr/share/terminfo

	sed -i -e \
		"s~@TIC@ \(\$(srcdir)/etc/rxvt\)~@TIC@ -o ${D}/${tdir} \1~" \
		doc/Makefile.in
}

src_compile() {
	myconf=''

	use iso14755 || myconf='--disable-iso14755'

	econf \
		--enable-everything \
		$(use_enable truetype xft) \
		$(use_enable afterimage) \
		$(use_enable perl) \
		--disable-text-blink \
		${myconf} \
		|| die

	emake || die

	sed -i \
		-e 's/RXVT_BASENAME = "rxvt"/RXVT_BASENAME = "urxvt"/' \
		"${S}"/doc/rxvt-tabbed || die "tabs sed failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc README.FAQ Changes
	cd "${S}"/doc
	dodoc README* changes.txt etc/* rxvt-tabbed
}

pkg_postinst() {
	einfo "urxvt now always uses TERM=rxvt-unicode so that the"
	einfo "upstream-supplied terminfo files can be used."
}
