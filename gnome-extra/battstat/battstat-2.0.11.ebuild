# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/battstat/battstat-2.0.11.ebuild,v 1.6 2002/10/05 05:39:13 drobbins Exp $

IUSE="nls"

S=${WORKDIR}/battstat_applet-${PV}
DESCRIPTION="Battstat Applet, GNOME battery status applet."
SRC_URI="http://download.sourceforge.net/battstat/battstat_applet-${PV}.tar.gz"
HOMEPAGE="http://battstat.sourceforge.net"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc
	>=gnome-base/gnome-libs-1.4.1.2-r1
	>=gnome-base/gnome-core-1.4.0.4-r1
	>=sys-apps/apmd-3.0.1
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls \
		|| myconf="--disable-nls"
#		&& myconf="--localedir=/usr/share/locale" \

	econf ${myconf} || die
	emake || die
}

src_install () {

	make \
		DESTDIR=${D} \
		gnomeconfdir=${D}/etc \
		gnomedatadir=${D}/usr/share \
		gnulocaledir=${D}/usr/share/locale \
		install || die
	
	rm ${D}/topic.dat

	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
