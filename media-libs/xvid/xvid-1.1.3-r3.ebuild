# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xvid/xvid-1.1.3-r3.ebuild,v 1.1 2008/03/01 18:58:02 aballier Exp $

inherit eutils fixheadtails autotools

MY_P=${PN}core-${PV}

DESCRIPTION="XviD, a high performance/quality MPEG-4 video de-/encoding solution"
HOMEPAGE="http://www.xvid.org"
SRC_URI="http://downloads.xvid.org/downloads/${MY_P}.tar.bz2
	mirror://gentoo/${PN}-1.1.2-noexec-stack.patch.bz2
	mirror://gentoo/${P}-textrel-3.patch.bz2"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples altivec"

# once yasm-0.6.0+ comes out, we can switch this to
# dev-lang/nasm >=dev-lang/yasm-0.6.0
# and then drop the quotes from section in the noexec-stack.patch

# yasm < 0.6.2 has a bug when computing pic adresses.
# See http://www.tortall.net/projects/yasm/ticket/114
# the build system prefers yasm if it finds it
# thus if we intend to have || (yasm nasm) for building
# we need to make it block yasm < 0.6.2 on x86
# otherwise it will compile wrong code
NASM=">=dev-lang/yasm-0.6.2"
DEPEND="x86? ( ${NASM} )
	amd64? ( ${NASM} )"
RDEPEND=""

S="${WORKDIR}"/${MY_P}/build/generic

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"/${MY_P}
	epatch "${FILESDIR}"/${PN}-1.1.0_beta2-altivec.patch
	epatch "${WORKDIR}"/${PN}-1.1.2-noexec-stack.patch
	epatch "${FILESDIR}"/${PN}-1.1.0-3dnow-2.patch
	epatch "${FILESDIR}"/${P}-ia64-build.patch
	epatch "${WORKDIR}/${P}-textrel-3.patch"
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf $(use_enable altivec)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	dodoc "${S}"/../../{AUTHORS,ChangeLog*,README,TODO}

	if [[ ${CHOST} == *-darwin* ]]; then
		local mylib=$(basename $(ls "${D}"/usr/$(get_libdir)/libxvidcore.*.dylib))
		dosym ${mylib} /usr/$(get_libdir)/libxvidcore.dylib
	else
		local mylib=$(basename $(ls "${D}"/usr/$(get_libdir)/libxvidcore.so*))
		dosym ${mylib} /usr/$(get_libdir)/libxvidcore.so
		dosym ${mylib} /usr/$(get_libdir)/${mylib/.1}
	fi

	if use examples; then
		dodoc "${S}"/../../CodingStyle
		insinto /usr/share/${PN}
		doins -r "${S}"/../../examples
	fi
}
