# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/prc-tools/prc-tools-2.3-r2.ebuild,v 1.6 2007/10/15 09:04:26 opfer Exp $

inherit flag-o-matic eutils toolchain-funcs

BIN_V="binutils-2.14"
GDB_V="gdb-5.3"
GCC_V_ARM="gcc-3.3.1"
GCC_V_M68K="gcc-2.95.3"
MSECT_V="MsectGdb2.3-1Patch"

DESCRIPTION="GNU-Based Palm C++ Development Suite"
HOMEPAGE="http://prc-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/prc-tools/${P}.tar.gz
	ftp://sources.redhat.com/pub/binutils/releases/${BIN_V}.tar.bz2
	ftp://sources.redhat.com/pub/gdb/releases/${GDB_V}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/releases/${GCC_V_ARM}/${GCC_V_ARM}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/releases/${GCC_V_M68K}/${GCC_V_M68K}.tar.bz2
	http://www.v-overbeek.nl/msectgdb/${MSECT_V}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE=""
DEPEND=">=app-text/texi2html-1.70"

RDEPEND=""

src_unpack() {
	unpack ${A}

	cd "${P}"
	ln -s ../${BIN_V} binutils
	ln -s ../${GDB_V} gdb
	ln -s ../${GCC_V_ARM} gcc
	ln -s ../${GCC_V_M68K} gcc295
	cd ..

	echo ">>> Patching sources..."
	echo -n " "; epatch "${P}/${BIN_V}.palmos.diff"
	echo -n " "; epatch "${P}/${GCC_V_ARM}.palmos.diff"
	echo -n " "; epatch "${P}/${GCC_V_M68K}.palmos.diff"
	echo -n " "; epatch "${P}/${GDB_V}.palmos.diff"
	echo -n " "; EPATCH_OPTS="-l" epatch "${P}/../MsectGdb2.3-1.diff"
	echo -n " "; epatch "${FILESDIR}/${P}-compilefix.patch"
	echo -n " "; epatch "${FILESDIR}/${P}-gcc4.patch"

		# This last patch disables dummy headers being copied.
			# a) They're not needed
			# b) This causes a sandboxing error
			# +) Keeps 'palmdev-prep' pointed at the
			#    right place while making the docs install
			#    script from not install them to real root /

	# Fix ${GCC_V_ARM} include problem
	cp ${GCC_V_ARM}/gcc/fixinc/tests/base/unistd.h ${GCC_V_ARM}/gcc
	sed -i -e 's:#include <stdio.h>::' -e 's:#include <sys/types.h>::' -e 's:#include <errno.h>::' -e 's:#include <stdlib.h>::' ${GCC_V_ARM}/gcc/tsystem.h || die
}

src_config() {
	echo ">>> Rebuilding configuration scripts"
	cd binutils
	WANT_AUTOCONF=2.1 autoconf || die "Failed to reconfigure binutils"
	cd ..

	cd ..
	mkdir build
	cd build

	echo ">>> Configuring..."
	echo

	# Remove any flags; because the cross-compiler (2.9.x GCC)
	# will not understand any of these optimizations {and will
	# fail} once the cross-compiler compiles the m68k GCC suite

	ALLOWED_FLAGS="-pipe -O -O1 -O2"
	strip-flags

	local targets
	if [ "$(gcc-major-version)" -ge '4' ]
	then
		ewarn "Disabling ARM support as the 3.3 GCC prc-tools uses can't be"
		ewarn "compiled using your GCC4+ compiler. Switch to GCC 3.x and rerun"
		ewarn "the merge to get ARM support."
		echo
	else
		targets=',arm-palmos'
	fi

	# econf not possible as this seems to rely on from where it has been started
	# will not debug further as this is a maintainer-needed ebuild
	../${P}/configure --enable-targets=m68k-palmos"${targets}" \
	--enable-languages=c,c++ \
	--with-headers="${WORKDIR}/build/empty" --enable-html-docs \
	--with-palmdev-prefix=/opt/palmdev --prefix=/usr || die

	# These have to be real; otherwise the compiler is hard-coded
	# and tries to find libraries in ${D}/....

	# palmdev-prefix also has to be real; otherwise 'palmdev-prep'
	# defaults to virtual ${D}/..

	# Make sure the newly built compiler is found; #100879.
	export PATH="$PATH:${D}/usr/bin"
}

src_compile() {
	src_config
	emake -j1 || die
}

src_install() {
	cd ../build
	export PATH="$PATH:${D}/usr/bin"
	einstall || die
	# fix file collisions
	rm -rf "${D}"/usr/share/locale/
	rm -f "${D}"/usr/share/info/gdb.info*
	rm -f "${D}"/usr/share/info/gdbint*
	rm -f "${D}"/usr/share/info/standards.info*
	rm -f "${D}"/usr/share/info/stabs.info*
}

pkg_postinst() {
	elog
	elog "PRC-Tools is now compiled and installed!"
	elog "<HTML docs are installed in /opt/palmdev>"
	elog
	elog "For a complete Palm Development Environment you will also need..."
	elog
	elog "[ ] PilRC; the Palm resource compiler; emerge pilrc"
	elog "[ ] POSE; The Palm OS Emulator"
	elog  "   ->> A ROM for POSE; available from Palm"
	elog "[ ] An SDK; emerge dev-lang/palmos-sdk"
	elog
}
