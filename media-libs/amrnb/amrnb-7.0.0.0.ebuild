# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/amrnb/amrnb-7.0.0.0.ebuild,v 1.9 2008/05/25 09:03:07 aballier Exp $

SPEC_VER="26104-700"

DESCRIPTION="Wrapper library for 3GPP Adaptive Multi-Rate Floating-point Speech Codec"
HOMEPAGE="http://www.penguin.cz/~utx/amr"
SRC_URI="http://ftp.penguin.cz/pub/users/utx/amr/${P}.tar.bz2
	http://www.3gpp.org/ftp/Specs/archive/26_series/26.104/${SPEC_VER}.zip"
RESTRICT="mirror"
LICENSE="LGPL-2 as-is"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND=""
DEPEND="app-arch/unzip"

src_unpack() {
	unpack ${P}.tar.bz2
	cd "${S}"
	cp "${DISTDIR}"/${SPEC_VER}.zip .
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TODO
}
