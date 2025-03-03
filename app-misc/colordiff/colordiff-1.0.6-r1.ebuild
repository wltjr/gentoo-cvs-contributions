# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/colordiff/colordiff-1.0.6-r1.ebuild,v 1.9 2008/04/25 20:39:02 ricmm Exp $

DESCRIPTION="Colorizes output of diff"
HOMEPAGE="http://colordiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/colordiff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-apps/diffutils"

src_unpack() {
	unpack $A
	cd $S
	# option name is wrong in configs #152141
	sed -i 's/\(color_patch\)es/\1/g' colordiffrc*
}

src_compile() {
	true
}

src_install() {
	newbin colordiff.pl colordiff || die
	newbin cdiff.sh cdiff || die
	insinto /etc
	doins colordiffrc colordiffrc-lightbg
	dodoc BUGS CHANGES README TODO
	doman colordiff.1
}
