# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-urbanterror/quake3-urbanterror-3.1-r1.ebuild,v 1.1 2003/10/14 02:14:22 vapier Exp $

MOD_DESC="total transformation realism based MOD"
MOD_NAME=q3ut3
MOD_BINS=ut3
inherit games games-q3mod

HOMEPAGE="http://www.urbanterror.net/"
SRC_URI="urbanterror3.zip
	UrbanTerror31.zip"

LICENSE="freedist"
SLOT="3"
RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please goto ${HOMEPAGE}"
	einfo "and download ${A} into ${DISTDIR}"
}

src_unpack() {
	unpack urbanterror3.zip
	cd q3ut3
	unpack UrbanTerror31.zip
}
