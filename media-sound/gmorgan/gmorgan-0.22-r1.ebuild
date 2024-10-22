# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmorgan/gmorgan-0.22-r1.ebuild,v 1.6 2005/11/07 10:47:00 flameeyes Exp $

DESCRIPTION="gmorgan is an opensource software rhythm station."
HOMEPAGE="http://personal.telefonica.terra.es/web/soudfontcombi/"
SRC_URI="http://personal.telefonica.terra.es/web/soudfontcombi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"

IUSE="nls"

RDEPEND=">=x11-libs/fltk-1.1.2
	>=media-libs/alsa-lib-0.9.0"

DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.11.5-r1 )"

src_unpack() {
	unpack ${A}
	cd ${S}/po
	sed -i "/mkinstalldirs =/s%.*%mkinstalldirs = ../mkinstalldirs%" Makefile.in.in
}

src_install() {
	make prefix=${D}/usr localedir=${D}/usr/share/locale install || die
	dodoc AUTHORS NEWS README
}
