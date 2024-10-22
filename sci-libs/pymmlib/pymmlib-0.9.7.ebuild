# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/pymmlib/pymmlib-0.9.7.ebuild,v 1.6 2008/05/29 17:54:58 hawking Exp $

inherit python multilib

DESCRIPTION="Software toolkit and library of routines for the analysis and manipulation of macromolecular structural models"
HOMEPAGE="http://pymmlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/pymmlib/${P}.tar.gz"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
RDEPEND="virtual/glut
	dev-python/pygtkglext
	dev-python/numeric
	virtual/opengl
	virtual/glu
	x11-libs/libXmu"
DEPEND="${RDEPEND}"

src_compile() {
	python setup.py build || die "build failed"
}

src_install() {
	python setup.py install --prefix="${D}/usr" || die "install failed"
	dobin "${S}"/applications/* "${S}"/examples/*
	dodoc "${S}"/README.txt
	dohtml -r "${S}"/doc
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/mmLib
}
