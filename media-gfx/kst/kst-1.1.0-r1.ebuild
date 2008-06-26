# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kst/kst-1.1.0-r1.ebuild,v 1.4 2008/06/26 13:58:51 markusle Exp $

inherit kde

DESCRIPTION="A plotting and data viewing program for KDE."
HOMEPAGE="http://kst.kde.org/"
SRC_URI="http://mirrors.isc.org/pub/kde/stable/apps/KDE3.x/scientific/${P}.tar.gz"

KEYWORDS="amd64 ~ppc ~sparc ~x86"
LICENSE="GPL-2"

SLOT="0"
IUSE=""

RDEPEND="${DEPEND}
	sci-libs/gsl"

need-kde 3.1

PATCHES=( "${FILESDIR}/${P}-netcdf-fix.patch" )

src_unpack(){
	kde_src_unpack
	einfo "Regenerating autotools files..."
	rm -f configure
	autoconf || die "autoconf failed"
}
