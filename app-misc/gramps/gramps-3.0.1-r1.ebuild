# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gramps/gramps-3.0.1-r1.ebuild,v 1.8 2008/07/24 23:14:04 opfer Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools eutils gnome2 python

DESCRIPTION="Genealogical Research and Analysis Management Programming System"
HOMEPAGE="http://www.gramps-project.org/"
SRC_URI="mirror://sourceforge/gramps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="reports"

RDEPEND=">=dev-lang/python-2.5
	>=dev-python/pygtk-2.10.0
	>=dev-python/gnome-python-2.6
	reports? ( media-gfx/graphviz )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/libiconv
	dev-util/pkgconfig
	app-text/gnome-doc-utils"

DOCS="NEWS README TODO"

pkg_setup() {
	if ! built_with_use 'dev-lang/python' berkdb ; then
		eerror "You need to install python with Berkely Database support."
		eerror "Add 'dev-lang/python berkdb' to /etc/portage/package.use "
		eerror "and then re-emerge python."
		die "berkdb support missing from gnome"
	fi

	G2CONF="${G2CONF} --disable-mime-install"
}

src_unpack() {
	gnome2_src_unpack
	# will be fixed in 3.0.2
	epatch "${FILESDIR}"/${P}-no_scrollkeeper.patch
	eautoreconf
	# This is for bug 215944, so .pyo/.pyc files don't get into the
	# file system
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/share/${PN}
}
