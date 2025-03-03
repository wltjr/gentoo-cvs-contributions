# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmgrabimage/wmgrabimage-0.72-r1.ebuild,v 1.7 2008/06/29 14:11:34 drac Exp $

inherit eutils

MY_P=${PN/grabi/GrabI}

DESCRIPTION="wmGrabImage grabs an image from the WWW and displays it"
SRC_URI="http://www.dockapps.com/download.php/id/19/${MY_P}-${PV}.tgz"
HOMEPAGE="http://www.dockapps.com/file.php/id/12"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND=">=net-misc/wget-1.9-r2
	>=media-gfx/imagemagick-5.5.7.15
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

S=${WORKDIR}/${MY_P}-${PV}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-noman.patch
	sed -i -e 's/-geom /-geometry /' GrabImage || die "sed failed."
}

src_compile() {
	emake clean || die "emake clean failed."
	emake CFLAGS="${CFLAGS} -Wall" || die "emake failed."
}

src_install() {
	dodir /usr/bin
	einstall DESTDIR="${D}/usr" || die "einstall failed."

	doman wmGrabImage.1

	dodoc ../{BUGS,CHANGES,HINTS,TODO}

	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop
}
