# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/valgrind/valgrind-3.2.3-r1.ebuild,v 1.5 2008/01/14 20:22:39 dertobi123 Exp $

inherit autotools eutils flag-o-matic toolchain-funcs

DESCRIPTION="An open-source memory debugger for GNU/Linux"
HOMEPAGE="http://www.valgrind.org"
SRC_URI="http://www.valgrind.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 ppc ppc64 ~x86"
IUSE="X"

# bug #49147 (bogus stacktrace in gdb with --db-attach=yes) does not seem to be applicable anymore
#RESTRICT="strip"

RDEPEND="!dev-util/callgrind"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# make sure our CFLAGS are respected
	einfo "Changing configure.in to respect CFLAGS"
	sed -i -e 's:^CFLAGS="-Wno-long-long":CFLAGS="$CFLAGS -Wno-long-long":' configure.in

	# undefined references to __guard and __stack_smash_handler in VEX (bug #114347)
	einfo "Changing Makefile.flags.am to disable SSP"
	sed -i -e 's:^AM_CFLAGS_BASE = :AM_CFLAGS_BASE = -fno-stack-protector :' Makefile.flags.am

	# Correct hard coded doc location
	sed -i -e "s:doc/valgrind:doc/${P}:" docs/Makefile.am

	# Fix incorrect --libs output in valgrind.pc (bug #147904)
	epatch "${FILESDIR}/${P}-pkg-config.patch"

	# Remove defaulting to ppc32-linux on ppc64 without multilib
	# "valgrind: failed to start tool 'memcheck' for platform 'ppc32-linux':
	#  No such file or directory"
	if use ppc64 && ! has_multilib_profile; then
		epatch "${FILESDIR}/valgrind-3.2.1-only64bit.patch"
	fi

	epatch "${FILESDIR}/${P}-glibc-2.6.patch"
	epatch "${FILESDIR}/${P}-glibc-2.7.patch"

	# Prevent "unhandled instruction bytes: 0x66 0x66 0x66 0x66" (bug #189396)
	epatch "${FILESDIR}/${P}-unhandled-instr-amd64.patch"

	# Regenerate autotools files
	eautoreconf
}

src_compile() {
	local myconf

	# -fomit-frame-pointer	"Assembler messages: Error: junk `8' after expression"
	#                       while compiling insn_sse.c in none/tests/x86
	# -fpie                 valgrind seemingly hangs when built with pie on
	#                       amd64 (bug #102157)
	# -fstack-protector     more undefined references to __guard and __stack_smash_handler
	#                       because valgrind doesn't link to glibc (bug #114347)
	# -ggdb3                segmentation fault on startup
	filter-flags -fomit-frame-pointer
	filter-flags -fpie
	filter-flags -fstack-protector
	replace-flags -ggdb3 -ggdb2

	# gcc 3.3.x fails to compile valgrind with -O3 (bug #129776)
	if [ "$(gcc-version)" == "3.3" ] && is-flagq -O3; then
		ewarn "GCC 3.3 cannot compile valgrind with -O3 in CFLAGS, using -O2 instead."
		replace-flags -O3 -O2
	fi

	# Optionally build in X suppression files
	use X && myconf="--with-x" || myconf="--with-x=no"

	if use amd64 || use ppc64; then
		! has_multilib_profile && myconf="${myconf} --enable-only64bit"
	fi

	econf ${myconf} || die "Configure failed!"
	emake || die "Make failed!"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed!"
	dodoc ACKNOWLEDGEMENTS AUTHORS FAQ.txt NEWS README*
}
