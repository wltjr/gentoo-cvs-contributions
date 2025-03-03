# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/matchbox/matchbox-0.7.1.ebuild,v 1.13 2008/02/27 17:26:40 yvasilev Exp $

inherit flag-o-matic

IUSE="jpeg png nls debug"

DESCRIPTION="Light weight WM designed for use on PDA computers"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://handhelds.org/~mallum/downloadables/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc x86"

RDEPEND="x11-libs/libXtst
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXft
	dev-libs/expat
	x11-libs/startup-notification
	x11-libs/libxsettings-client
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )"

DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	sys-devel/libtool"

src_compile() {
	local myconf
	myconf="${myconf} --enable-dnotify"
	myconf="${myconf} --enable-expat"
	myconf="${myconf} --enable-sn"
	myconf="${myconf} --enable-xsettings"
	use nls && myconf="${myconf} --enable-nls"
	use jpeg && myconf="${myconf} --enable-jpg"
	use png || myconf="${myconf} --disable-png"
	use debug && myconf="${myconf} --enable-debug"

	append-ldflags -Wl,--no-as-needed

	econf ${myconf} || die "Configuration failed"
	emake || die "Make feiled"
}

src_install() {
	einstall || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS \
	      README RELEASE-NOTES-0.7 TODO
}
