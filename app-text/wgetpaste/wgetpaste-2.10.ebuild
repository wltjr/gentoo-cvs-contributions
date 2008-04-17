# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wgetpaste/wgetpaste-2.10.ebuild,v 1.4 2008/04/17 18:13:08 nixnut Exp $

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="http://wgetpaste.zlin.dk/"
SRC_URI="http://wgetpaste.zlin.dk/${PF}.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	newbin ${P} ${PN}
}
