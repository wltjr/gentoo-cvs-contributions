# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gscmxx/gscmxx-0.4.1-r1.ebuild,v 1.5 2005/01/01 15:05:50 eradicator Exp $

inherit perl-module eutils

DESCRIPTION="A frontend for scmxx (exchange data with Siemens phones)."
HOMEPAGE="http://gscmxx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND=">=app-misc/scmxx-0.6
	>=dev-lang/perl-5.005
	>=dev-perl/gtk-perl-0.7008
	>=x11-libs/gtk+-1.2.8
	>=dev-perl/ImageSize-2.92
	media-gfx/imagemagick"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-destdir.diff
}
