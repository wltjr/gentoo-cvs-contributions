# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gnat-gcc/gnat-gcc-4.3.1.ebuild,v 1.2 2008/06/25 14:27:44 george Exp $

inherit gnatbuild

DESCRIPTION="GNAT Ada Compiler - gcc version"
HOMEPAGE="http://gcc.gnu.org/"
LICENSE="GMGPL"

# overriding the BOOT_SLOT, as 4.1 should do fine, no need for bootstrap duplication
BOOT_SLOT="4.1"

# SLOT is set in gnatbuild.eclass, depends only on PV (basically SLOT=GCCBRANCH)
# so the URI's are static.
SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-core-${PV}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-ada-${PV}.tar.bz2
	ppc?   ( mirror://gentoo/gnatboot-${BOOT_SLOT}-ppc.tar.bz2 )
	x86?   ( mirror://gentoo/gnatboot-${BOOT_SLOT}-i386.tar.bz2 )
	amd64? ( mirror://gentoo/gnatboot-${BOOT_SLOT}-amd64.tar.bz2 )"

KEYWORDS="~amd64 ~ppc ~x86"

# starting with 4.3.0 gnat needs these libs
DEPEND=">=dev-libs/mpfr-2.3.1
	>=dev-libs/gmp-4.2.2"

QA_EXECSTACK="${BINPATH:1}/gnatls ${BINPATH:1}/gnatbind ${BINPATH:1}/gnatmake
	${LIBEXECPATH:1}/gnat1 ${LIBPATH:1}/adalib/libgnat-${SLOT}.so"

src_unpack() {
	gnatbuild_src_unpack

	#fixup some hardwired flags
	cd "${S}"/gcc/ada

	# universal gcc -> gnatgcc substitution occasionally produces lines too long
	# and then build halts on the style check.
	#
	# The sed in makegpr.adb is actually not for the line length but rather to
	# "undo" the fixing, Last3 is matching just that - the last three characters
	# of the compiler name.
	sed -i -e 's:(Last3 = "gnatgcc"):(Last3 = "gcc"):' makegpr.adb &&
	sed -i -e 's:and Nam is "gnatgcc":and Nam is "gcc":' osint.ads ||
		die	"reversing [gnat]gcc substitution in comments failed"

	# Looks like old bootstrap cannot process new C syntax..
	sed -i -e "/-DREVISION/d" -e "/-DDEVPHASE/d" \
		-e "s: -DDATESTAMP=\$(DATESTAMP_s)::" "${S}"/gcc/Makefile.in
	sed -i -e "s: DATESTAMP DEVPHASE REVISION::" \
		-e "s:PKGVERSION:\"\":" "${S}"/gcc/version.c
}

src_compile() {
	# looks like gnatlib_and_tools and gnatlib_shared have become part of
	# bootstrap
	gnatbuild_src_compile configure make-tools bootstrap
}
