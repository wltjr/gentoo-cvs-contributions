# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/massxpert/massxpert-1.7.6.ebuild,v 1.3 2008/07/20 14:22:03 loki_val Exp $

EAPI=1

inherit base eutils flag-o-matic cmake-utils

DESCRIPTION="A software suite to predict/analyze mass spectrometric data on (bio)polymers."
HOMEPAGE="http://massxpert.org/wiki/"
SRC_URI="http://download.tuxfamily.org/massxpert/source/${PF}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="|| (
		( x11-libs/qt-gui:4 x11-libs/qt-svg:4 x11-libs/qt-xmlpatterns:4 x11-libs/qt-core:4 )
		=x11-libs/qt-4.3*:4
	)
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXfixes
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libX11
	sys-libs/zlib
	media-libs/freetype
	media-libs/fontconfig
	media-libs/nas
	media-libs/libpng
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.7"

S="${WORKDIR}/${P}"
CMAKE_IN_SOURCE_BUILD="true"

PATCHES=( "${FILESDIR}/${P}-gcc43.patch" )

pkg_setup() {
	if has_version '=x11-libs/qt-4.3*'
	then
		if ! built_with_use '>x11-libs/qt-4.3' accessibility
		then
			eerror "qt-4 must be built with the accessibility USE flag."
			die "qt-4 must be built with the accessibility USE flag.."
		fi
	else
		if ! built_with_use '>x11-libs/qt-gui-4.4' accessibility
		then
			eerror "qt-gui must be built with the accessibility USE flag."
			die "qt-gui must be built with the accessibility USE flag.."
		fi
	fi
}

src_compile() {
	sed -i \
		-e "s:/lib/:/$(get_libdir)/:g" \
		-e "s:ADD_DEFINITIONS (-Wall -Werror):ADD_DEFINITIONS (-Wall):" \
		CMakeLists.txt || \
		die "404. File not found while sedding."

	tc-export CC CXX LD
	mycmakeargs="-D__LIB=$(get_libdir)"

	if use amd64 ; then
		append-flags -fPIC
	fi

	cmake-utils_src_compile
}
