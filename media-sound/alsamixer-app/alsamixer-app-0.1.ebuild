# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsamixer-app/alsamixer-app-0.1.ebuild,v 1.1 2008/06/28 05:46:35 drac Exp $

inherit eutils toolchain-funcs

MY_PN=AlsaMixer.app
MY_P=${MY_PN}-${PV}

DESCRIPTION="AlsaMixer.app is a simple mixer dockapp"
HOMEPAGE="http://dockapps.org/file.php/id/253"
SRC_URI="http://dockapps.org/download.php/id/517/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext
	media-libs/alsa-lib"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	tc-export CXX
	emake || die "emake failed."
}

src_install() {
	dobin ${MY_PN} || die "dobin failed."
	dodoc README
}
