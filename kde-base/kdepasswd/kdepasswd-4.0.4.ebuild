# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepasswd/kdepasswd-4.0.4.ebuild,v 1.1 2008/05/15 23:22:26 ingmar Exp $

EAPI="1"

KMNAME=kdebase
KMMODULE=apps/${PN}

inherit kde4-meta

DESCRIPTION="KDE GUI for passwd"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/libkonq-${PV}:${SLOT}"
RDEPEND="${DEPEND}
	>=kde-base/kdesu-${PV}:${SLOT}"

KMLOADLIBS="libkonq"
