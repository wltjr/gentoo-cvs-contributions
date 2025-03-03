# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/ncurses/ncurses-5.6-r2.ebuild,v 1.11 2008/04/20 16:53:33 flameeyes Exp $

inherit eutils flag-o-matic toolchain-funcs

MY_PV=${PV:0:3}
PV_SNAP=${PV:4}
MY_P=${PN}-${MY_PV}
DESCRIPTION="console display library"
HOMEPAGE="http://www.gnu.org/software/ncurses/ http://dickey.his.com/ncurses/"
SRC_URI="mirror://gnu/ncurses/${MY_P}.tar.gz
	ftp://invisible-island.net/ncurses/${PV}/${P}-coverity.patch.gz"

LICENSE="MIT"
SLOT="5"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="debug doc gpm minimal nocxx profile trace unicode"

DEPEND="gpm? ( sys-libs/gpm )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	[[ -n ${PV_SNAP} ]] && epatch "${WORKDIR}"/${MY_P}-${PV_SNAP}-patch.sh
	epatch "${WORKDIR}"/${P}-coverity.patch
	epatch "${FILESDIR}"/${PN}-5.6-gfbsd.patch
	epatch "${FILESDIR}"/${PN}-5.6-build.patch #184700
}

src_compile() {
	tc-export BUILD_CC

	# Protect the user from themselves #115036
	unset TERMINFO

	local myconf=""
	use nocxx && myconf="${myconf} --without-cxx --without-cxx-binding"
	use ada || myconf="${myconf} --without-ada"

	# First we build the regular ncurses ...
	mkdir "${WORKDIR}"/narrowc
	cd "${WORKDIR}"/narrowc
	do_compile ${myconf}

	# Then we build the UTF-8 version
	if use unicode ; then
		mkdir "${WORKDIR}"/widec
		cd "${WORKDIR}"/widec
		do_compile ${myconf} --enable-widec --includedir=/usr/include/ncursesw
	fi
}
do_compile() {
	ECONF_SOURCE=${S}

	# We need the basic terminfo files in /etc, bug #37026.  We will
	# add '--with-terminfo-dirs' and then populate /etc/terminfo in
	# src_install() ...
	# The chtype/mmask-t settings below are to retain ABI compat
	# with ncurses-5.4 so dont change em !
	local conf_abi="
		--with-chtype=long \
		--with-mmask-t=long \
		--disable-ext-colors \
		--disable-ext-mouse \
	"
	econf \
		--libdir="/$(get_libdir)" \
		--with-terminfo-dirs="/etc/terminfo:/usr/share/terminfo" \
		--with-shared \
		$(use_with debug) \
		$(use_with profile) \
		$(use_with gpm) \
		--disable-termcap \
		--enable-symlinks \
		--with-rcs-ids \
		--with-manpage-format=normal \
		--enable-const \
		--enable-colorfgbg \
		--enable-echo \
		$(use_enable !ada warnings) \
		$(use_with debug assertions) \
		$(use_with !debug leaks) \
		$(use_with debug expanded) \
		$(use_with !debug macros) \
		$(use_with trace) \
		${conf_abi} \
		"$@" \
		|| die "configure failed"

	# A little hack to fix parallel builds ... they break when
	# generating sources so if we generate the sources first (in
	# non-parallel), we can then build the rest of the package
	# in parallel.  This is not really a perf hit since the source
	# generation is quite small.  -vapier
	emake -j1 sources || die "make sources failed"
	emake || die "make failed"
}

src_install() {
	# install unicode version second so that the binaries in /usr/bin
	# support both wide and narrow
	cd "${WORKDIR}"/narrowc
	emake DESTDIR="${D}" install || die "make narrowc install failed"
	if use unicode ; then
		cd "${WORKDIR}"/widec
		emake DESTDIR="${D}" install || die "make widec install failed"
	fi

	# Move static and extraneous ncurses libraries out of /lib
	dodir /usr/$(get_libdir)
	cd "${D}"/$(get_libdir)
	mv lib{form,menu,panel}.so* *.a "${D}"/usr/$(get_libdir)/
	gen_usr_ldscript lib{,n}curses.so
	if use unicode ; then
		mv lib{form,menu,panel}w.so* "${D}"/usr/$(get_libdir)/
		gen_usr_ldscript lib{,n}cursesw.so
	fi

	# We need the basic terminfo files in /etc, bug #37026
	einfo "Installing basic terminfo files in /etc..."
	for x in ansi console dumb linux rxvt screen sun vt{52,100,102,200,220} \
			 xterm xterm-color xterm-xfree86
	do
		local termfile=$(find "${D}"/usr/share/terminfo/ -name "${x}" 2>/dev/null)
		local basedir=$(basename $(dirname "${termfile}"))

		if [[ -n ${termfile} ]] ; then
			dodir /etc/terminfo/${basedir}
			mv ${termfile} "${D}"/etc/terminfo/${basedir}/
			dosym ../../../../etc/terminfo/${basedir}/${x} \
				/usr/share/terminfo/${basedir}/${x}
		fi
	done

	# Build fails to create this ...
	dosym ../share/terminfo /usr/$(get_libdir)/terminfo

	echo "CONFIG_PROTECT_MASK=\"/etc/terminfo\"" > "${T}"/50ncurses
	doenvd "${T}"/50ncurses

	use minimal && rm -r "${D}"/usr/share/terminfo
	cd "${S}"
	dodoc ANNOUNCE MANIFEST NEWS README* TO-DO doc/*.doc
	use doc && dohtml -r doc/html/
}

pkg_preinst() {
	use unicode || preserve_old_lib /$(get_libdir)/libncursesw.so.5
}

pkg_postinst() {
	use unicode || preserve_old_lib_notify /$(get_libdir)/libncursesw.so.5
}
