# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/lapack-atlas/lapack-atlas-3.6.0.ebuild,v 1.16 2008/04/06 11:27:10 bicatali Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Full LAPACK implementation using available ATLAS routines"
HOMEPAGE="http://math-atlas.sourceforge.net/"
MY_PN=${PN/lapack-/}
SRC_URI1="mirror://sourceforge/math-atlas/${MY_PN}${PV}.tar.bz2"
SRC_URI2="http://www.netlib.org/lapack/lapack-3.0.tgz"
SRC_URI="${SRC_URI1} ${SRC_URI2}
	mirror://gentoo/lapack-20020531-20021004.patch.bz2
	mirror://gentoo/lapack-gentoo.patch
	mirror://gentoo/${MY_PN}3.6.0-shared-libs.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE="doc"

DEPEND="virtual/libc
	>=sys-devel/libtool-1.5
	~sci-libs/blas-atlas-3.6.0
	sci-libs/lapack-config"

RDEPEND="virtual/libc
	virtual/blas"

S=${WORKDIR}/ATLAS
S_LAPACK=${WORKDIR}/LAPACK

TOP_PATH="${DESTTREE}/lib/lapack"
# Path where libraries will be installed:
RPATH="${TOP_PATH}/atlas"

FORTRAN="ifc g77"

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}"
	epatch "${FILESDIR}"/unbuffered.patch
	epatch "${DISTDIR}"/atlas3.6.0-shared-libs.patch.bz2
	epatch "${DISTDIR}"/lapack-20020531-20021004.patch.bz2
	epatch "${DISTDIR}"/lapack-gentoo.patch
	cp "${FILESDIR}"/war "${S}"
	chmod a+x "${S}"/war
}

atlas_fail() {
	eerror
	eerror "ATLAS auto-config failed."
	eerror "Please run 'interactive=1 emerge lapack-atlas' to configure"
	eerror "manually."
	eerror
	die "ATLAS auto-config failed."
}

src_compile() {
	if [ -n "${interactive}" ]
	then
		echo "${interactive}"
		make config CC="$(tc-getCC) -DUSE_LIBTOOL -DINTERACTIVE" || die
	else
		# Use ATLAS defaults for all questions:
		(echo | make config CC="$(tc-getCC) -DUSE_LIBTOOL") || atlas_fail
	fi

	TMPSTR=$(ls Make.Linux*)
	ATLAS_ARCH=${TMPSTR#'Make.'}

	CC="libtool --mode=compile --tag=CC $(tc-getCC) -I/usr/include/atlas"

	cd "${S}"/src/lapack/${ATLAS_ARCH}
	make lib CC="${CC}" || die

	cd "${S}"/interfaces/lapack/C/src/${ATLAS_ARCH}
	make lib CC="${CC}" || die

	cd "${S}"/interfaces/lapack/F77/src/${ATLAS_ARCH}

	make lib CC="${CC}" F77="libtool --mode=compile --tag=F77 g77" || die

	cd ${S_LAPACK}
	if [[ ${FORTRANC} = if* ]]
	then
		FC="${FORTRANC}"
		NOOPT="-O0" # Do NOT change this. It is applied to two files with
					# routines to determine machine constants.
	else
		FC="g77"
		# g77 hates opts, esp. machine-specific
		ALLOWED_FLAGS="-O -O1 -O2 -fstack-protector -fno-unit-at-a-time \
						-pipe -g -Wall"
		strip-flags
		FFLAGS="${CFLAGS}"
		NOOPT=""
	fi
	make lapacklib FORTRAN="libtool --mode=compile --tag=F77 ${FC}" OPTS="${FFLAGS}" \
		NOOPT="${NOOPT}" || die

	cd ${S_LAPACK}/SRC
	cp -sf "${S}"/gentoo/liblapack.a/*.o .
	cp -sf "${S}"/gentoo/liblapack.a/*.lo .
	cp -sf "${S}"/gentoo/liblapack.a/.libs/*.o .libs/

	if [[ ${FORTRAN} = if* ]]
	then
		${FORTRANC} ${FFLAGS} -shared .libs/*.o -Wl,-soname -Wl,liblapack.so.0 \
			-o liblapack.so.0.0.0 -lblas -lcblas -latlas \
			-L$(gcc-config -L) -lg2c
		ar cru liblapack.a *.o
		ranlib liblapack.a
	else
		libtool --mode=link --tag=CC $(tc-getCC) -o liblapack.la *.lo \
			-rpath ${RPATH} -lblas -lcblas -latlas -lg2c
	fi
}

src_install () {
	dodir ${RPATH}

	cd ${S_LAPACK}/SRC
	if [[ ${FORTRANC} = if* ]]
	then
		strip --strip-unneeded liblapack.so.0.0.0
		strip --strip-debug liblapack.a

		exeinto ${RPATH}
		doexe liblapack.so.0.0.0
		dosym liblapack.so.0.0.0 ${RPATH}/liblapack.so.0
		dosym liblapack.so.0.0.0 ${RPATH}/liblapack.so

		insinto ${RPATH}
		doins liblapack.a
	else
		libtool --mode=install install -s liblapack.la "${D}"/${RPATH}
	fi

	insinto ${TOP_PATH}
	doins "${FILESDIR}"/f77-ATLAS

	insinto /usr/include/atlas
	cd "${S}"/include
	doins clapack.h || die "failed to install clapack.h"

	cd "${S}"
	dodoc README
	cd "${S}"/doc
	dodoc AtlasCredits.txt ChangeLog
	if use doc;
	then
		dodoc lapackqref.ps
	fi
}

pkg_postinst() {
	/usr/bin/lapack-config ATLAS

	einfo
	einfo "To link with ATLAS LAPACK from C or Fortran, simply use:"
	einfo
	einfo "-llapack"
	einfo
	einfo "C users: your header is /usr/include/atlas/clapack.h"
	einfo
}
