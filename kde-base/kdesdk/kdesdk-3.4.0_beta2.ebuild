# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk/kdesdk-3.4.0_beta2.ebuild,v 1.1 2005/02/09 16:23:25 greg_g Exp $

inherit kde-dist

DESCRIPTION="KDE SDK: Cervisia, KBabel, KCachegrind, Kompare, Umbrello,..."

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="x86? ( dev-util/callgrind )
	media-gfx/graphviz
	sys-devel/flex"

RDEPEND="${DEPEND}
	dev-util/cvs"
