# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/windowlab/windowlab-1.34.ebuild,v 1.5 2007/08/24 18:03:35 dertobi123 Exp $

inherit eutils

DESCRIPTION="small and simple window manager of novel design."
HOMEPAGE="http://www.nickgravgaard.com/windowlab/"
SRC_URI="http://www.nickgravgaard.com/${PN}/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86"
IUSE="truetype"

RDEPEND="truetype? ( virtual/xft )
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-1.34-fixed-font.patch"
}

src_compile() {
	if use truetype ; then
		export DEFINES=-DXFT
		export EXTRA_INC=$(pkg-config --cflags xft)
		export EXTRA_LIBS=$(pkg-config --libs xft)
	fi
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin ${PN} || die

	newman ${PN}.1x ${PN}.1 || die
	dodoc CHANGELOG README TODO || die

	dodir /etc/X11/${PN} || die
	insinto /etc/X11/${PN}
	doins ${PN}.menurc || die

	dodir /etc/X11/Sessions || die
	echo "/usr/bin/${PN}" > ${D}/etc/X11/Sessions/${PN}
	fperms a+x /etc/X11/Sessions/${PN}
}

pkg_postinst() {
	elog "${PN}'s menu config file has been changed from"
	elog "/etc/X11/${PN}/menurc to /etc/X11/${PN}/${PN}.menurc"
}
