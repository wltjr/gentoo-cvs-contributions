# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/rox-session/rox-session-0.30.ebuild,v 1.7 2008/01/03 18:49:26 lack Exp $

ROX_LIB_VER="2.0.0"
inherit eutils rox multilib

DESCRIPTION="Rox-Session is a really simple session manager"
HOMEPAGE="http://rox.sourceforge.net/rox_session.html"
SRC_URI="mirror://sourceforge/rox/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND=">=dev-python/dbus-python-0.71"
DEPEND="!rox-base/zeroinstall-injector"

MY_PN="ROX-Session"
APPNAME=${MY_PN}

src_install() {
	rox_src_install

	dobin "${FILESDIR}/rox-start"

	local wm="rox"
	make_session_desktop "ROX Desktop" /usr/bin/rox-start

	dodir /etc/X11/Sessions
	echo "/usr/bin/rox-start" > "${D}/etc/X11/Sessions/ROX_Desktop"
	fperms a+x /etc/X11/Sessions/ROX_Desktop
}

pkg_postinst() {
	echo
	einfo "ROX-Session has been installed into ${APPDIR}"
	einfo "Please review its documentation about proper use. A symlink"
	einfo "for the executable has been created as /usr/bin/${WRAPPERNAME}."
	echo
	einfo "It has also been installed as an X Session, so you should be"
	einfo "able to select it in the Session list of gdm or kdm"
}
