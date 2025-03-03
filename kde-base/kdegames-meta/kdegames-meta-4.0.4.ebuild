# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegames-meta/kdegames-meta-4.0.4.ebuild,v 1.1 2008/05/15 23:17:23 ingmar Exp $

EAPI="1"

inherit kde4-functions

DESCRIPTION="kdegames - merge this to pull in all kdegames-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="kde-4"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

RDEPEND="
	>=kde-base/bovo-${PV}:${SLOT}
	>=kde-base/katomic-${PV}:${SLOT}
	>=kde-base/kbattleship-${PV}:${SLOT}
	>=kde-base/kblackbox-${PV}:${SLOT}
	>=kde-base/kbounce-${PV}:${SLOT}
	>=kde-base/kfourinline-${PV}:${SLOT}
	>=kde-base/kgoldrunner-${PV}:${SLOT}
	>=kde-base/kiriki-${PV}:${SLOT}
	>=kde-base/kjumpingcube-${PV}:${SLOT}
	>=kde-base/klines-${PV}:${SLOT}
	>=kde-base/kmahjongg-${PV}:${SLOT}
	>=kde-base/kmines-${PV}:${SLOT}
	>=kde-base/knetwalk-${PV}:${SLOT}
	>=kde-base/kolf-${PV}:${SLOT}
	>=kde-base/konquest-${PV}:${SLOT}
	>=kde-base/kpat-${PV}:${SLOT}
	>=kde-base/kreversi-${PV}:${SLOT}
	>=kde-base/ksame-${PV}:${SLOT}
	>=kde-base/kshisen-${PV}:${SLOT}
	>=kde-base/kspaceduel-${PV}:${SLOT}
	>=kde-base/ksquares-${PV}:${SLOT}
	>=kde-base/ktuberling-${PV}:${SLOT}
	>=kde-base/lskat-${PV}:${SLOT}
	opengl? ( >=kde-base/ksudoku-${PV}:${SLOT} )
"
