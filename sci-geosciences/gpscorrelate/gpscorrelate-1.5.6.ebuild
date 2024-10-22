# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gpscorrelate/gpscorrelate-1.5.6.ebuild,v 1.2 2008/06/16 23:29:23 jer Exp $

inherit eutils

DESCRIPTION="Tool for adjusting EXIF tags of your photos with a recorded GPS trace"
HOMEPAGE="http://freefoote.dview.net/linux_gpscorr.html"
SRC_URI="http://freefoote.dview.net/linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~hppa ~x86"
IUSE="doc gtk"
DEPEND="dev-libs/libxml2
	media-gfx/exiv2
	gtk? ( >=x11-libs/gtk+-2 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-cflags.patch
}

src_compile() {
	emake gpscorrelate || die
	if use gtk; then
		emake gpscorrelate-gui || die
	fi
}

src_install() {
	dobin gpscorrelate
	if use gtk; then
		dobin gpscorrelate-gui
	fi
	if use doc; then
		dohtml doc/* || die
	fi
	doman "${FILESDIR}"/${PN}.1 || die
	make_desktop_entry gpscorrelate-gui GPSCorrelate "" "Photography;Graphics;Geography;"
}
