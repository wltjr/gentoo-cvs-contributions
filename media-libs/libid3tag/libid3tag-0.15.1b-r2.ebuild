# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libid3tag/libid3tag-0.15.1b-r2.ebuild,v 1.6 2008/05/07 18:46:14 corsair Exp $

inherit eutils multilib

DESCRIPTION="The MAD id3tag library"
HOMEPAGE="http://www.underbit.com/products/mad/"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="debug"

DEPEND="dev-util/gperf"

RDEPEND="${DEPEND}
	>=sys-libs/zlib-1.1.3"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epunt_cxx #74489

	epatch "${FILESDIR}/${PV}"/*.patch
}

src_compile() {
	econf $(use_enable debug debugging) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"

	dodoc CHANGES CREDITS README TODO VERSION

	# This file must be updated with every version update
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${FILESDIR}/id3tag.pc"
	sed -i -e "s:libdir=\${exec_prefix}/lib:libdir=/usr/$(get_libdir):" \
		-e "s:0.15.0b:${PV}:" \
		"${D}/usr/$(get_libdir)/pkgconfig/id3tag.pc"
}
