# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/boost-build/boost-build-1.34.1.ebuild,v 1.14 2008/05/05 17:47:46 jer Exp $

inherit flag-o-matic toolchain-funcs versionator

MY_PV=$(replace_all_version_separators _)

DESCRIPTION="A system for large project software construction, which is simple to use and powerful."
HOMEPAGE="http://www.boost.org/tools/build/v2/index.html"
SRC_URI="mirror://sourceforge/boost/boost_${MY_PV}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="python"

DEPEND="!<dev-libs/boost-1.34.0
	python? ( dev-lang/python )"
RDEPEND=""

S=${WORKDIR}/boost_${MY_PV}/tools

src_unpack() {
	unpack ${A}

	# Remove stripping option
	cd "${S}/jam/src"
	sed -i \
		-e 's/-s\b//' \
		build.jam || die "sed failed"

	# This patch allows us to fully control optimization
	# and stripping flags when bjam is used as build-system
	# We simply extend the optimization and debug-symbols feature
	# with empty dummies called 'none'
	cd "${S}/build/v2"
	sed -i \
		-e 's/\(feature optimization : off speed space\)/\1 none/' \
		-e 's/\(feature debug-symbols : on off\)/\1 none/' \
		tools/builtin.jam || die "sed failed"
}

src_compile() {
	cd jam/src
	local toolset

	if [[ ${CHOST} == *-darwin* ]] ; then
		toolset=darwin
	else
		# Using boost's generic toolset here, which respects CC and CFLAGS
		toolset=cc
	fi

	append-flags -fno-strict-aliasing

	# The build.jam file for building bjam using a bootstrapped jam0 ignores
	# the LDFLAGS env var (bug #209794). We have now two options:
	# a) change the cc-target definition in build.jam to include separate compile
	#    and link targets to make it use the LDFLAGS var, or
	# b) a simple dirty workaround by injecting the LDFLAGS in the LIBS env var
	#    (which should not be set by us).
	if [[ -z "${LDFLAGS}" ]] ; then
		CC=$(tc-getCC) ./build.sh ${toolset} $(use_with python) \
			|| die "building bjam failed"
	else
		LIBS=${LDFLAGS} CC=$(tc-getCC) ./build.sh ${toolset} \
			$(use_with python) || die "building bjam failed"
	fi
}

src_install() {
	dobin jam/src/bin.*/bjam || die

	cd "${S}/build/v2"
	insinto /usr/share/boost-build
	doins -r boost-build.jam bootstrap.jam build-system.jam site-config.jam user-config.jam \
		build kernel options tools util || die
}
