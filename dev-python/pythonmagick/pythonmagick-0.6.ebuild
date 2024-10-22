# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pythonmagick/pythonmagick-0.6.ebuild,v 1.4 2008/07/20 11:38:42 loki_val Exp $

inherit eutils python multilib toolchain-funcs

KEYWORDS="~x86"

MY_PN=PythonMagick

DESCRIPTION="Python bindings for ImageMagick"
SRC_URI="http://www.imagemagick.org/download/python/${MY_PN}-${PV}.tar.gz"
HOMEPAGE="http://www.imagemagick.org/script/api.php"
SLOT="0"
LICENSE="as-is"
IUSE=""

RDEPEND=">=media-gfx/imagemagick-1.1.7
	>=dev-libs/boost-1.34.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/scons"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo_misc_fixes.patch"
}

src_compile() {
	python_version
	sed -i \
		-e "s#\(BOOST\)=.*#\1='/usr/include/boost'#" \
		-e "s#\(BOOSTLIBPATH\)=.*#\1='/usr/lib'#" \
		-e "s#\(PYTHONINCLUDE\)=.*#\1='/usr/include/python${PYVER}'#" \
		-e "s#\(Environment(\)#\1 CXX='$(tc-getCXX)',#" \
		-e "s#\(CPPFLAGS\)=#\1='${CXXFLAGS}'.split()+#" \
		SConstruct || die "sed failed"

	# FIXME: Until we have a var or function for it
	numjobs=$(sed -e 's/.*\(\-j[ 0-9]\+\) .*/\1/' <<< ${MAKEOPTS})

	scons mode=release ${numjobs} || die "scons failed"
}

src_install() {
	insinto /usr/$(get_libdir)/python${PYVER}/site-packages
	doins -r PythonMagick
}
