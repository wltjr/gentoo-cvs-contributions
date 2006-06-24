# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/djvu/djvu-3.5.14-r1.ebuild,v 1.4 2006/06/24 05:27:42 cardoe Exp $

inherit nsplugins flag-o-matic fdo-mime

MY_P="${PN}libre-${PV}"

DESCRIPTION="DjVu viewers, encoders and utilities."
HOMEPAGE="http://djvu.sourceforge.net"
SRC_URI="mirror://sourceforge/djvu/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
IUSE="xml qt3 jpeg tiff debug threads nls nsplugin kde"

DEPEND="jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( media-libs/tiff )
	qt3? ( <x11-libs/qt-4 )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	# Replace autochecking acdesktop.m4 with a gentoo-specific one
	cp ${FILESDIR}/gentoo-acdesktop.m4 ${S}/gui/desktop/acdesktop.m4

	cd ${S}
	aclocal -I config -I gui/desktop || die "aclocal failed"
	autoconf || die "autoconf failed"
	libtoolize --copy --force
}

src_compile() {
	# assembler problems and hence non-building with pentium4 
	# <obz@gentoo.org>
	replace-flags -march=pentium4 -march=pentium3

	if use kde; then
		export kde_mimelnk=/usr/share/mimelnk
	fi

	econf --enable-desktopfiles \
		$(use_enable xml xmltools) \
		$(use_with qt3 qt) \
		$(use_with jpeg) \
		$(use_with tiff) \
		$(use_enable threads) \
		$(use_enable nls i18n) \
		$(use_enable debug) \
		|| die "econf failed"

	if ! use nsplugin; then
		sed -e 's:nsdjvu::' -i ${S}/gui/Makefile
	fi

	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR=${D} plugindir=${D}/usr/lib/${PLUGINS_DIR} install
}
