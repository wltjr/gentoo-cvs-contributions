# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libqxt/libqxt-0.2.5.ebuild,v 1.3 2008/07/27 01:22:24 carlo Exp $

EAPI="1"
inherit eutils qt4

DESCRIPTION="The Qt eXTension library provides cross-platform utility classes to add functionality ontop of the Qt toolkit"
HOMEPAGE="http://libqxt.org/"
SRC_URI="mirror://sourceforge/libqxt/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="ssl fastcgi debug"

DEPEND="
	|| ( ( x11-libs/qt-gui:4
		x11-libs/qt-script:4
		x11-libs/qt-sql:4 )
	=x11-libs/qt-4.3*:4 )
	ssl? ( >=dev-libs/openssl-0.9.8 )
	fastcgi? ( >=dev-libs/fcgi-2.4 )"
RDEPEND="${DEPEND}"

QT4_BUILT_WITH_USE_CHECK="png ssl"

src_compile() {
	local myconf

	use debug && myconf="${myconf} -debug"
	use !ssl && myconf="${myconf} -nomake crypto"
	use !fastcgi && myconf="${myconf} -nomake web"

	./configure -prefix /usr ${myconf}

	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
