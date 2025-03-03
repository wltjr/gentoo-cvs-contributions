# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/lua/lua-5.1.1-r2.ebuild,v 1.17 2008/02/12 21:21:25 mabi Exp $

inherit eutils portability versionator

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="readline static"

DEPEND="readline? ( sys-libs/readline )"

src_unpack() {
	local PATCH_PV=$(get_version_component_range 1-2)
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-${PATCH_PV}-make.patch
	epatch "${FILESDIR}"/${PN}-${PATCH_PV}-module_paths.patch

	# extra patching not required in lua-5.1.3
	sed -i -e 's:\(INSTALL_.*\= \$(CP)\):#\1:g' Makefile
	sed -i -e 's:#\(INSTALL_.*\= \$(INSTALL)\):\1:g' Makefile

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html

	if ! use readline ; then
		epatch "${FILESDIR}"/${PN}-${PATCH_PV}-readline.patch
	fi

	# Using dynamic linked lua is not recommended upstream for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86
	# Note that the lua compiler is build statically anyway
	if use static ; then
		epatch "${FILESDIR}"/${PN}-${PATCH_PV}-make_static.patch
	fi

	# We want packages to find our things...
	sed -i -e 's:/usr/local:/usr:' etc/lua.pc
}

src_compile() {
	myflags=
	# what to link to liblua
	liblibs="-lm"
	mycflags="${mycflags} -DLUA_USE_LINUX"
	liblibs="${liblibs} $(dlopen_lib)"

	# what to link to the executables
	mylibs=
	if use readline; then
		mylibs="-lreadline"
	fi

	cd src
	emake CFLAGS="${mycflags} ${CFLAGS}" \
			RPATH="/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=${PV} \
			gentoo_all || die "emake failed"

	mv lua_test ../test/lua.static
}

src_install() {
	emake INSTALL_TOP="${D}/usr/" INSTALL_LIB="${D}/usr/$(get_libdir)/" \
			V=${PV} gentoo_install \
	|| die "emake install gentoo_install failed"

	dodoc HISTORY README
	dohtml doc/*.html doc/*.gif

	insinto /usr/share/pixmaps
	doins etc/lua.ico
	insinto /usr/$(get_libdir)/pkgconfig
	doins etc/lua.pc
}

src_test() {
	local positive="bisect cf echo env factorial fib fibfor hello printf sieve
	sort trace-calls trace-globals"
	local negative="readonly"
	local test

	cd "${S}"
	for test in ${positive}; do
		test/lua.static test/${test}.lua &> /dev/null || die "test $test failed"
	done

	for test in ${negative}; do
		test/lua.static test/${test}.lua &> /dev/null && die "test $test failed"
	done
}
