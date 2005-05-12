# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeedu/kdeedu-3.4.0.ebuild,v 1.4 2005/05/12 20:33:02 agriffis Exp $

inherit kde-dist

DESCRIPTION="KDE educational apps"

KEYWORDS="~x86 ~amd64 ~sparc ~ppc ~ia64"
IUSE="kig-scripting"

DEPEND="kig-scripting? ( >=dev-libs/boost-1.32 )"

src_compile() {
	myconf="$(use_enable kig-scripting kig-python-scripting)"

	kde_src_compile
}
