# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.1.24-r1.ebuild,v 1.1 2008/07/31 20:47:40 eva Exp $

inherit libtool eutils python autotools

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="crypt debug examples python"

DEPEND=">=dev-libs/libxml2-2.6.27
	crypt?  ( >=dev-libs/libgcrypt-1.1.92 )
	python? ( dev-lang/python )"

SRC_URI="ftp://xmlsoft.org/${PN}/${P}.tar.gz"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# we still require the 1.1.8 patch for the .m4 file, to add
	# the CXXFLAGS defines <obz@gentoo.org>
	epatch "${FILESDIR}/libxslt.m4-${PN}-1.1.8.patch"

	# fix parallel install, bug #212784.
	epatch "${FILESDIR}/${PN}-1.1.23-parallel-install.patch"

	# Patch Makefile to fix bug #99382 so that html gets installed in ${PF}
	sed -i -e "s:libxslt-\$(VERSION):${PF}:" doc/Makefile.am

	# Fix broken <python-2.5 site-packages detection
	# see bug #86756 and bug #218643
	python_version
	sed -i "s:^\(AC_SUBST(PYTHON_SITE_PACKAGES)\):PYTHON_SITE_PACKAGES=\"/usr/$(get_libdir)/python${PYVER}/site-packages\"\n\1:" configure.in

	# Fix broken rc4 encrypt.  bug #232172
	epatch "${FILESDIR}/${P}-exslt_crypt.patch"

	eautoreconf
	epunt_cxx
	elibtoolize
}

src_compile() {
	# Always pass --with-debugger. It is required by third parties (see
	# e.g. bug #98345)
	local myconf="--with-debugger \
		$(use_with python)       \
		$(use_with crypt crypto) \
		$(use_with debug)        \
		$(use_with debug mem-debug)"

	econf ${myconf} || die "configure failed"

	emake || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog Copyright FEATURES NEWS README TODO

	if ! use examples; then
		rm -rf "${D}/usr/share/doc/${PN}-python-${PV}/examples"
	fi
}
