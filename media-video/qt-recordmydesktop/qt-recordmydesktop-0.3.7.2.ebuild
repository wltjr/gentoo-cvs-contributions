# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/qt-recordmydesktop/qt-recordmydesktop-0.3.7.2.ebuild,v 1.4 2008/07/27 01:14:03 carlo Exp $

inherit qt4

DESCRIPTION="QT4 interface for RecordMyDesktop"
HOMEPAGE="http://recordmydesktop.iovar.org/"
SRC_URI="mirror://sourceforge/recordmydesktop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""
# Test is buggy : bug #186752
# Tries to run intl-toolupdate without it being substituted from
# configure, make test tries run make check in flumotion/test what
# makes me think that this file has been copied from flumotion without
# much care...
RESTRICT="test"

RDEPEND="|| ( x11-libs/qt-gui =x11-libs/qt-4.3* )
	>=dev-python/PyQt4-4.1
	>=media-video/recordmydesktop-0.3.5"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc NEWS README AUTHORS ChangeLog
}
