# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxdg-basedir/libxdg-basedir-0.1.4.ebuild,v 1.1 2008/07/04 15:03:46 flameeyes Exp $

inherit libtool

DESCRIPTION="Small library to access XDG Base Directories Specification paths"
HOMEPAGE="http://n.ethz.ch/student/nevillm/download/libxdg-basedir/"
SRC_URI="http://n.ethz.ch/student/nevillm/download/libxdg-basedir/${P}.tar.gz"

IUSE="doc"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	elibtoolize
}

src_compile() {
	econf \
		--disable-dependency-tracking \
		$(use_enable doc doxygen-html) \
		|| die "econf failed"

	emake || die "emake failed"

	if use doc; then
		emake -j1 doxygen-doc || die "emake doxygen-doc failed"
	fi
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	if use doc; then
		dohtml -r doc/html/*
	fi

	# Remove libtool archives, as the package has no dependencies,
	# and should be used with pkg-config properly.
	find "${D}" -name '*.la' -delete
}
