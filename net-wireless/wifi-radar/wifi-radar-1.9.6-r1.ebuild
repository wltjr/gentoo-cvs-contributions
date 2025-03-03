# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wifi-radar/wifi-radar-1.9.6-r1.ebuild,v 1.4 2008/02/29 20:33:46 carlo Exp $

inherit eutils

DESCRIPTION="WiFi Radar is a Python/PyGTK2 utility for managing WiFi profiles."
HOMEPAGE="http://wifi-radar.systemimager.org/"
SRC_URI="http://wifi-radar.systemimager.org/pub/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="svg"

RDEPEND=">=dev-python/pygtk-2.6.1
	>=net-wireless/wireless-tools-27-r1"

src_install ()
{
	dosbin wifi-radar
	dosed "s:/etc/conf.d:/etc:g" /usr/sbin/wifi-radar
	dobin wifi-radar.sh
	dodir /etc/wifi-radar
	insinto /etc/wifi-radar; doins wifi-radar.conf
	if use svg; then
		doicon pixmaps/wifi-radar.svg
		make_desktop_entry wifi-radar.sh "WiFi Radar" wifi-radar Network
	else
		doicon pixmaps/wifi-radar.png
		make_desktop_entry wifi-radar.sh "WiFi Radar" wifi-radar Network
	fi
	doman wifi-radar.1 wifi-radar.conf.5
	dodoc AUTHORS ChangeLog README TODO
}

pkg_postinst()
{
	einfo "Remember to edit configuration file /etc/wifi-radar.conf to suit your needs..."
	echo
	einfo "To use wifi-radar with a normal user (with sudo) add:"
	einfo "%users   ALL = /usr/sbin/wifi-radar"
	einfo ""
	einfo "in your /etc/sudoers then launch wifi-radar.sh"
	echo
}
