# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/py-rrdtool/py-rrdtool-1.0_beta1.ebuild,v 1.2 2007/11/24 09:47:35 drac Exp $

inherit eutils distutils

IUSE=""
DESCRIPTION="Python wrapper for RRDtool"
SRC_URI="mirror://sourceforge/py-rrdtool/${P/_beta/b}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/py-rrdtool/"

KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
LICENSE="LGPL-2.1"
SLOT="0"

DEPEND="virtual/python
	>=net-analyzer/rrdtool-1.2"

S=${WORKDIR}/${P/_beta/b}
