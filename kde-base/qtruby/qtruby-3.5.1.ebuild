# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/qtruby/qtruby-3.5.1.ebuild,v 1.2 2006/01/23 18:46:58 danarmak Exp $

KMNAME=kdebindings
KMCOPYLIB="libsmokeqt smoke/qt"
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Ruby bindings for QT"
HOMEPAGE="http://developer.kde.org/language-bindings/ruby/"

KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=" >=virtual/ruby-1.8
$(deprange 3.5.0-r1 $MAXKDEVER kde-base/smoke)"

PATCHES="$FILESDIR/no-gtk-glib-check.diff"

# Because this installs into /usr/lib/ruby/..., it doesn't have SLOT=X.Y like the rest of KDE,
# and it installs into /usr entirely.
# Note that it still depends on a specific range of (slotted) smoke versions.
SLOT="0"
src_compile() {
	kde_src_compile myconf
	myconf="$myconf --prefix=/usr"
	kde_src_compile configure make
}
