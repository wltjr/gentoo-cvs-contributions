# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmousetool/kmousetool-4.0.5.ebuild,v 1.1 2008/06/05 22:01:26 keytoaster Exp $

EAPI="1"

KMNAME=kdeaccessibility
inherit kde4-meta

DESCRIPTION="KDE accessibility tool: translates mouse hovering into clicks"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

RDEPEND="
	>=kde-base/knotify-${PV}:${SLOT}
	>=kde-base/phonon-${PV}:${SLOT}"
