# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/nvtv/nvtv-0.4.6.ebuild,v 1.5 2005/11/09 12:13:46 swegener Exp $

IUSE="X gtk"

DESCRIPTION="TV-Out for NVidia cards"
HOMEPAGE="http://sourceforge.net/projects/nv-tv-out/"
SRC_URI="mirror://sourceforge/nv-tv-out/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND="sys-apps/pciutils
	gtk? ( x11-libs/gtk+ )
	X? ( virtual/x11 )"

src_compile() {
	local myconf

	if use gtk
	then
		myconf="${myconf} --with-gtk"
	else
		myconf="${myconf} --without-gtk"
	fi

	use X \
		&& myconf="${myconf} --with-x" \
		|| myconf="${myconf} --without-x"

	econf ${myconf} || die

	# The CFLAGS don't seem to make it into the Makefile.
	cd src
	emake CXFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin src/nvtv
	dosbin src/nvtvd

	dodoc ANNOUNCE BUGS FAQ INSTALL README \
		doc/USAGE doc/chips.txt doc/overview.txt \
		doc/timing.txt xine/tvxine

	exeinto /etc/init.d
	newexe ${FILESDIR}/nvtv.start nvtv
}
