# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libusb/libusb-0.1.7-r1.ebuild,v 1.5 2004/06/24 23:25:28 agriffis Exp $

DESCRIPTION="Userspace access to USB devices"
HOMEPAGE="http://libusb.sourceforge.net/"
SRC_URI="mirror://sourceforge/libusb/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc alpha amd64 ia64"

DEPEND="virtual/glibc
	doc? ( app-text/openjade =app-text/docbook-sgml-dtd-3.1-r1 )"

src_compile() {
	local myconf
	use doc \
		&& myconf="--enable-build-docs" \
		|| myconf="--disable-build-docs"
	use debug \
		&& myconf="${myconf} --enable-debug=all" \
		|| myconf="${myconf} --disable-debug"
	econf ${myconf} || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS NEWS README || die
	if use doc; then
		dohtml doc/html/*.html || die
	fi
}
