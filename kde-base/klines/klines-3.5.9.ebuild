# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/klines/klines-3.5.9.ebuild,v 1.7 2008/05/18 20:11:28 maekke Exp $
KMNAME=kdegames
EAPI="1"
inherit kde-meta

DESCRIPTION="KDE: Kolor Lines - a little game about balls and how to get rid of them"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"

DEPEND=">=kde-base/libkdegames-${PV}:${SLOT}"
RDEPEND="${DEPEND}"

KMEXTRACTONLY=libkdegames
KMCOPYLIB="libkdegames libkdegames"
