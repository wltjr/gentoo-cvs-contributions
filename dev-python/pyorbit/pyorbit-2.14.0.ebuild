# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyorbit/pyorbit-2.14.0.ebuild,v 1.10 2006/09/04 06:29:28 vapier Exp $

inherit python gnome2

DESCRIPTION="ORBit2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.4
	>=gnome-base/orbit-2.12"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

src_unpack() {

	unpack ${A}
	# disable pyc compiling
	mv ${S}/py-compile ${S}/py-compile.orig
	ln -s /bin/true ${S}/py-compile

}

src_install() {

	gnome2_src_install

	python_version
	mv ${D}/usr/lib/python${PYVER}/site-packages/CORBA.py \
		${D}/usr/lib/python${PYVER}/site-packages/pyorbit_CORBA.py

	mv ${D}/usr/lib/python${PYVER}/site-packages/PortableServer.py \
		${D}/usr/lib/python${PYVER}/site-packages/pyorbit_PortableServer.py

}

pkg_postinst() {

	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages

}

pkg_postrm() {

	python_version
	python_mod_cleanup

}
