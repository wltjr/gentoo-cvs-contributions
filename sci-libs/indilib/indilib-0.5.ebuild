# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/indilib/indilib-0.5.ebuild,v 1.2 2008/06/09 12:04:02 flameeyes Exp $

inherit multilib eutils

DESCRIPTION="INDI Astronomical Control Protocol library"
HOMEPAGE="http://indi.sourceforge.net/index.php/Main_Page"
SRC_URI="mirror://sourceforge/indi/${PN}-${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="usb v4l2"

RDEPEND="sci-libs/cfitsio
		usb? ( dev-libs/libusb )
		v4l2? ( >=sys-kernel/linux-headers-2.6 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/indi"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}+gcc-4.3.patch
}

src_compile(){
	myconf="${myconf} $(use_enable usb) $(use_enable v4l2)"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "make install failed"
}
