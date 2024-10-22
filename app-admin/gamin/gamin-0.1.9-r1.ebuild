# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gamin/gamin-0.1.9-r1.ebuild,v 1.9 2008/07/14 05:15:34 jer Exp $

inherit autotools eutils flag-o-matic libtool python

DESCRIPTION="Library providing the FAM File Alteration Monitor API"
HOMEPAGE="http://www.gnome.org/~veillard/gamin/"
SRC_URI="http://www.gnome.org/~veillard/${PN}/sources/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="debug kernel_linux python"

RDEPEND=">=dev-libs/glib-2
	python? ( virtual/python )
	!app-admin/fam"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

PROVIDE="virtual/fam"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix compile warnings; bug #188923
	epatch "${FILESDIR}"/${P}-compile-warnings.patch
	epatch "${FILESDIR}/${P}-user-cflags.patch"
	epatch "${FILESDIR}/${P}-freebsd.patch"

	# autoconf is required as the user-cflags patch modifies configure.in
	# however, elibtoolize is also required, so when the above patch is
	# removed, replace the following call with a call to elibtoolize
	eautoreconf
}

src_compile() {
	# fixes bug 225403
	append-flags "-D_GNU_SOURCE"

	econf --disable-debug \
		$(use_enable kernel_linux inotify) \
		$(use_enable debug debug-api) \
		$(use_with python) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README TODO NEWS doc/*txt
	dohtml doc/*
}

pkg_postinst() {
	if use python; then
		python_version
		python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages
	fi
}

pkg_postrm() {
	if use python; then
		python_version
		python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages
	fi
}
