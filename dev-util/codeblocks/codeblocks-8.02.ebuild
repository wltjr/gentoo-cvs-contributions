# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/codeblocks/codeblocks-8.02.ebuild,v 1.2 2008/06/01 03:34:09 mr_bones_ Exp $

inherit autotools wxwidgets flag-o-matic eutils

WX_GTK_VER="2.8"

DESCRIPTION="free cross-platform C/C++ IDE"
HOMEPAGE="http://www.codeblocks.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
SRC_URI="mirror://sourceforge/codeblocks/${P}-src.tar.bz2"

IUSE="contrib debug pch static unicode"

RDEPEND="=x11-libs/wxGTK-${WX_GTK_VER}*
		x11-libs/gtk+"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.5.0
	>=sys-devel/automake-1.7
	>=sys-devel/libtool-1.4
	app-arch/zip"

pkg_setup() {
	if use unicode; then
		need-wxwidgets "unicode"
	else
		need-wxwidgets "gtk2"
	fi
}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${PV}-version.patch"
	#epatch "${FILESDIR}/${PV}-install-plugins.patch"
	cd "${S}"
	find src/plugins -name Makefile.am -exec \
		sed -i -e 's#^libdir#pluginsdir#' \
			   -e 's#^lib_LTLIBRARIES#plugins_LTLIBRARIES#' \
		'{}' \;
	# This one's buggy
	sed -i -e 's#^plugins_LTLIBRARIES#lib_LTLIBRARIES#' \
		src/plugins/contrib/wxSmith/Makefile.am

	eautoreconf || die "autoreconf failed"
#	./bootstrap || die "boostrap failed"
}

src_compile() {
	# C::B is picky on CXXFLAG -fomit-frame-pointer
	# (project-wizard crash, instability ...)
	filter-flags -fomit-frame-pointer
	append-flags -fno-strict-aliasing

	cd "${S}"
	local myconf="$(use_enable pch)"
#			$(use_enable autosave) \
#			$(use_enable class-wizard) \
#			$(use_enable code-completion) \
#			$(use_enable compiler) \
#			$(use_enable debuger) \
#			$(use_enable mime-handler) \
#			$(use_enable open-files-list) \
#
#			$(use_enable projects-importer) \
#			$(use_enable source-formatter) \
#			$(use_enable todo) \
#			$(use_enable xpmanifest)

	if use contrib; then
		myconf="${myconf} --with-contrib-plugins=all"
	fi
	econf	--with-wx-config="${WX_CONFIG}" \
			--enable-dependency-tracking \
			$(use_enable unicode) \
			$(use_enable debug) \
			$(use_enable static) \
			${myconf} || die "Died in action: econf ..."
	emake || die "Died in action: make ..."
}

src_install() {
	einstall || die "Install failed"
}
