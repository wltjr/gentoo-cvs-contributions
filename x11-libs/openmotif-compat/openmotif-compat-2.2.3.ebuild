# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/openmotif-compat/openmotif-compat-2.2.3.ebuild,v 1.5 2008/05/08 10:32:19 ulm Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.6"

inherit eutils flag-o-matic multilib autotools

MY_P=openMotif-${PV}
DESCRIPTION="Legacy Open Motif libraries for old binaries"
HOMEPAGE="http://www.motifzone.org/"
SRC_URI="ftp://ftp.ics.com/openmotif/2.2/${PV}/src/${MY_P}.tar.gz
	mirror://gentoo/openmotif-${PV}-patches-1.tar.bz2"

LICENSE="MOTIF libXpm"
SLOT="2.2"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="!x11-libs/motif-config
	!x11-libs/lesstif
	!=x11-libs/openmotif-2.2*
	x11-libs/libXmu
	x11-libs/libXp"

DEPEND="${RDEPEND}
	x11-libs/libXaw
	x11-misc/xbitmaps"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX=patch epatch

	# This replaces deprecated, obsoleted and now invalid AC_DEFINE
	# with their proper alternatives.
	sed -i -e 's:AC_DEFINE(\([^)]*\)):AC_DEFINE(\1, [], [\1]):g' \
		configure.in acinclude.m4

	# Build only the libraries
	sed -i -e '/^SUBDIRS/{:x;/\\$/{N;bx;};s/=.*/= lib clients/;}' Makefile.am
	sed -i -e '/^SUBDIRS/{:x;/\\$/{N;bx;};s/=.*/= uil/;}' clients/Makefile.am

	eautoreconf
}

src_compile() {
	# get around some LANG problems in make (#15119)
	unset LANG

	# bug #80421
	filter-flags -ftracer

	# multilib includes don't work right in this package...
	has_multilib_profile && append-flags "-I$(get_ml_incdir)"

	# feel free to fix properly if you care
	append-flags -fno-strict-aliasing

	econf --with-x || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install-exec || die "emake install failed"

	# cleanups
	rm -Rf "${D}"/usr/bin
	rm -f "${D}"/usr/$(get_libdir)/*.{so,la,a}

	dodoc README RELEASE RELNOTES BUGREPORT TODO
}
