# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/jargon/jargon-4.4.7.ebuild,v 1.5 2004/06/24 21:47:14 agriffis Exp $

DESCRIPTION="A comprehensive compendium of hacker slang illuminating many aspects of hackish tradition, folklore, and humor"
HOMEPAGE="http://www.catb.org/~esr/jargon"
SRC_URI="http://www.catb.org/~esr/jargon/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86 ppc ppc64 sparc mips alpha hppa amd64 ia64 "
IUSE=""

src_unpack() {
	unpack ${A}
	find ${S} -name .xvpics | xargs rm -rf
}

src_install() {
	dohtml -r html/*
}
