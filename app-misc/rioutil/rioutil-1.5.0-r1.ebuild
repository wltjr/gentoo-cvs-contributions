# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/rioutil/rioutil-1.5.0-r1.ebuild,v 1.3 2008/01/05 14:19:04 drac Exp $

inherit multilib

DESCRIPTION="Command line tool for transfering mp3s to and from a Rio 600, 800, Rio Riot, and Nike PSA/Play"
HOMEPAGE="http://rioutil.sourceforge.net/"
SRC_URI="mirror://sourceforge/rioutil/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="dev-libs/libusb"

src_install() {
	emake DESTDIR="${D}" libdir="/usr/$(get_libdir)" \
		install || die "emake install failed."

	dodoc AUTHORS ChangeLog NEWS README TODO
	insinto /etc/udev/rules.d
	doins "${FILESDIR}"/75-rio.rules
}
