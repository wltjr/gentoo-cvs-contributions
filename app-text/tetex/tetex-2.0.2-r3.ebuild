# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tetex/tetex-2.0.2-r3.ebuild,v 1.5 2004/02/21 12:17:18 usata Exp $

inherit tetex

DESCRIPTION="a complete TeX distribution"
HOMEPAGE="http://tug.org/teTeX/"
KEYWORDS="x86 ~ppc ~sparc alpha hppa ~amd64 ~ia64"

src_unpack() {
	tetex_src_unpack
	epatch ${FILESDIR}/${PN}-no-readlink-manpage.diff
}
