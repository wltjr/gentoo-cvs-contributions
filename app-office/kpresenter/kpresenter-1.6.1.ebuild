# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kpresenter/kpresenter-1.6.1.ebuild,v 1.9 2007/03/02 03:54:04 jer Exp $

KMNAME=koffice
MAXKOFFICEVER=${PV}
inherit kde-meta eutils

DESCRIPTION="KOffice presentation program."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store"

KMEXTRACTONLY="lib/"

KMCOMPILEONLY="filters/liboofilter"

KMEXTRA="filters/kpresenter
	filters/libdialogfilter"

need-kde 3.4

src_unpack() {
	kde-meta_src_unpack unpack

	# We need to compile filters first.
	echo "SUBDIRS = liboofilter libdialogfilter kpresenter" > $S/filters/Makefile.am

	for i in $(find ${S}/lib -iname "*\.ui"); do
		${QTDIR}/bin/uic ${i} > ${i%.ui}.h
	done

	kde-meta_src_unpack makefiles
}
