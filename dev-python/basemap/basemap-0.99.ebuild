# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/basemap/basemap-0.99.ebuild,v 1.1 2008/07/02 17:00:05 bicatali Exp $

inherit eutils distutils

DESCRIPTION="matplotlib toolkit to plot map projections"
HOMEPAGE="http://matplotlib.sourceforge.net/matplotlib.toolkits.basemap.basemap.html"
SRC_URI="mirror://sourceforge/matplotlib/${P}.tar.gz"

IUSE="doc examples"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT GPL-2"

CDEPEND="sci-libs/shapelib
	>=dev-python/matplotlib-0.98
	=sci-libs/geos-2.2.3*"

DEPEND="${CDEPEND}
	dev-python/setuptools"

RDEPEND="${CDEPEND}
	dev-python/dap"

DOCS="FAQ API_CHANGES"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# patch to use shapelib and geos system libraries
	# proj is unfortunately an internal patched version (bug #209895)
	epatch "${FILESDIR}"/${P}-syslib.patch
}

src_install() {
	distutils_src_install --install-data=/usr/share/${PN}
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins *.pdf || die
	fi
}
