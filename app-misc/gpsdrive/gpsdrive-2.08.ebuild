# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gpsdrive/gpsdrive-2.08.ebuild,v 1.5 2005/01/01 15:05:04 eradicator Exp $

DESCRIPTION="displays GPS position on a map"
HOMEPAGE="http://gpsdrive.kraftvoll.at"
SRC_URI="http://gpsdrive.kraftvoll.at/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 -ppc"

IUSE="nls"
DEPEND="sys-devel/gettext
	>=x11-libs/gtk+-2.0
	>=dev-libs/libpcre-4.2"

src_compile() {
	econf `use_enable nls` || die "econf failed"
	emake || die "compile failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
