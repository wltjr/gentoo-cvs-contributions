# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-extra/downloadmanager/downloadmanager-0.1.3.ebuild,v 1.5 2007/11/16 15:10:58 drac Exp $

ROX_LIB_VER=2.0.0
inherit rox eutils

MY_PN="DownloadManager"
DESCRIPTION="Download Manager - a downloader for the Fetch and the ROX Desktop"
HOMEPAGE="http://www.kerofin.demon.co.uk/rox/downloadmanager.html"
SRC_URI="http://www.kerofin.demon.co.uk/rox/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=rox-extra/fetch-0.1.0
		>=dev-python/dbus-python-0.71"

APPNAME=${MY_PN}
S=${WORKDIR}

src_install() {
	# Do normal ROX install first
	rox_src_install

	# Install DBUS session file
	insinto /usr/share/dbus-1/services
	doins "${FILESDIR}/uk.co.demon.kerofin.DownloadManager.service"
}
