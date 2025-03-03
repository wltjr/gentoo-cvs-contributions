# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-nimbus/gtk-engines-nimbus-0.0.12.ebuild,v 1.2 2008/04/10 14:41:15 drac Exp $

inherit libtool autotools gnome2-utils eutils

MY_PN=nimbus
MY_P=${MY_PN}-${PV}

DESCRIPTION="Nimbus GTK+ Engine from Sun JDS"
HOMEPAGE="http://dlc.sun.com/osol/jds/downloads/extras"
SRC_URI="http://dlc.sun.com/osol/jds/downloads/extras/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.1
	dev-util/intltool"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	intltoolize || die "intltoolize failed."
	eautoreconf
	elibtoolize
}

src_compile() {
	econf --disable-dependency-tracking
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog
}

pkg_postinst() {
	gnome2_icon_cache_update
}
