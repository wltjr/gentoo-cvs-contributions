# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-fontconfig/eselect-fontconfig-1.0.ebuild,v 1.3 2007/07/28 17:11:07 armin76 Exp $

DESCRIPTION="An eselect module to manage /etc/fonts/conf.d symlinks."
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~hppa ~ia64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect
		>=media-libs/fontconfig-2.4"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/fontconfig.eselect-${PV}" fontconfig.eselect || die
}
