# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-gammu/python-gammu-0.26.ebuild,v 1.1 2008/06/07 09:47:20 mrness Exp $

inherit distutils

DESCRIPTION="Python bindings for Gammu"
HOMEPAGE="http://www.cihar.com/gammu/python/"
SRC_URI="ftp://dl.cihar.com/python-gammu/v0/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=app-mobilephone/gammu-1.20.0"
DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_install() {
	DOCS="AUTHORS NEWS"
	distutils_src_install

	insinto /usr/share/doc/${PF}/examples
	doins examples/*.py
	insinto /usr/share/doc/${PF}/examples/data
	doins examples/data/*
}
