# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-kresources/kdepim-kresources-3.4.1.ebuild,v 1.4 2005/07/01 09:34:11 corsair Exp $

KMNAME=kdepim
KMMODULE=kresources
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE PIM groupware plugin collection"
KEYWORDS="amd64 ~ppc ppc64 ~sparc x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/libkpimexchange)
$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/kaddressbook)
$(deprange $PV $MAXKDEVER kde-base/kode)
	>=app-crypt/gpgme-0.4.0"
KMCOPYLIB="
	libkcal libkcal
	libkpimexchange libkpimexchange
	libkdepim libkdepim
	libkabinterfaces kaddressbook/interfaces/"

KMEXTRACTONLY="
	libkcal/
	korganizer/
	libkpimexchange/configure.in.in
	libkdepim/
	kmail/kmailicalIface.h
	libkpimexchange/
	libemailfunctions/"

KMCOMPILEONLY="
	knotes/
	kaddressbook/common/
	"
PATCHES="$FILESDIR/use-installed-kode.diff"

src_compile() {
	export DO_NOT_COMPILE="knotes"

	kde-meta_src_compile myconf configure

	cd knotes/; make libknotesresources.la

	kde-meta_src_compile make
}
