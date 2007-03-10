# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-smartbookmark/xfce4-smartbookmark-0.4.2.ebuild,v 1.14 2007/03/10 17:39:36 nixnut Exp $

inherit xfce44

xfce44
xfce44_gzipped
xfce44_goodies_panel_plugin

DESCRIPTION="Xfce panel smart-bookmark plugin"
KEYWORDS="amd64 hppa ppc ~ppc64 sparc x86 ~x86-fbsd"

src_unpack() {
	unpack ${A}
	sed -i -e 's:bugs.debian:bugs.gentoo:g' "${S}"/src/smartbookmark.c
}
