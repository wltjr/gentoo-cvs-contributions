# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/yafray/yafray-0.0.9-r1.ebuild,v 1.6 2008/04/29 15:00:19 drac Exp $

inherit eutils multilib python

DESCRIPTION="Yet Another Free Raytracer"
HOMEPAGE="http://www.yafray.org"
SRC_URI="http://www.yafray.org/sec/2/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE="openexr"

RDEPEND="media-libs/jpeg
	sys-libs/zlib
	openexr? ( media-libs/openexr )"
DEPEND="${RDEPEND}
	dev-util/scons"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-scons.patch \
		"${FILESDIR}"/${P}-libdir.patch \
		"${FILESDIR}"/${P}-etc.patch \
		"${FILESDIR}"/${P}-gcc43.patch

	sed -i -e "s:-O3:${CXXFLAGS} -fsigned-char:g" *-settings.py || die "sed	failed."
}

src_compile() {
	local exr_path=""
	use openexr && exr_path="/usr"

	scons ${MAKEOPTS} prefix="/usr" \
					  libdir="/$(get_libdir)" \
					  exr_path="$exr_path" || die
}

src_install() {
	scons prefix="/usr" destdir="${D}" libdir="/$(get_libdir)" install \
		|| die "scons install failed."

	find "${D}" -name .sconsign -exec rm \{\} \;
	dodoc AUTHORS
	dohtml doc/doc.html
}
