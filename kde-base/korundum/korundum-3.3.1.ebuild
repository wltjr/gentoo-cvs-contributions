# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/korundum/korundum-3.3.1.ebuild,v 1.4 2004/12/25 15:50:10 danarmak Exp $

KMNAME=kdebindings
KMCOPYLIB="libsmokeqt smoke/qt libsmokekde smoke/kde"
KMCOMPILEONLY="qtruby"
KM_MAKEFILESREV=1
MAXKDEVER=3.3.1
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE ruby bindings"
KEYWORDS="~x86"
IUSE=""
OLDDEPEND=">=virtual/ruby-1.8 ~kde-base/qtruby-$PV ~kde-base/smoke-$PV"
DEPEND=" >=virtual/ruby-1.8
$(deprange $PV $MAXKDEVER kde-base/qtruby)
$(deprange $PV $MAXKDEVER kde-base/smoke)"

PATCHES="$FILESDIR/no-gtk-glib-check.diff"


