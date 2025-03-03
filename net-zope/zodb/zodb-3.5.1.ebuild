# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zodb/zodb-3.5.1.ebuild,v 1.2 2006/01/27 02:51:32 vapier Exp $

inherit distutils

MY_P=ZODB
DESCRIPTION="Zope Object DataBase"
HOMEPAGE="http://zope.org/Products/ZODB3.5"
SRC_URI="http://zope.org/Products/${MY_P}3.5/${MY_P}%20${PV}/${MY_P}3-${PV}.tgz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.3.5"

S=${WORKDIR}/${MY_P}3-${PV}
