# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-biggles/python-biggles-1.6.4.ebuild,v 1.5 2007/08/24 23:12:49 coldwind Exp $

inherit distutils

MY_P=${P/python/python2}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A Python module for creating publication-quality 2D scientific plots."
SRC_URI="mirror://sourceforge/biggles/${MY_P}.tar.gz"
HOMEPAGE="http://biggles.sourceforge.net"

DEPEND="~media-libs/plotutils-2.4.1
	dev-python/numeric
	x11-libs/libSM
	x11-libs/libXext"
RDEPEND="${DEPEND}"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
LICENSE="GPL-2"

pkg_setup() {
	if ! built_with_use media-libs/plotutils X ; then
		eerror "${P} needs media-libs/plotutils built with"
		eerror "USE=\"X\", please rebuild it with X enabled"
		eerror "and emerge ${P} again."
		die "media-libs/plotutils built without USE=\"X\""
	fi
}

src_install() {
	distutils_src_install

	dodir /usr/share/doc/${PF}/examples
	cp -r examples/* ${D}/usr/share/doc/${PF}/examples
}
