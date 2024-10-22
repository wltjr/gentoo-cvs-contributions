# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/stat/stat-3.3.ebuild,v 1.7 2007/03/13 14:10:01 armin76 Exp $

inherit eutils

DESCRIPTION="A command-line stat() wrapper"
SRC_URI="ftp://metalab.unc.edu/pub/linux/utils/file/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/directory/stat.html"

KEYWORDS="~amd64 sparc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}

	cp Makefile Makefile.orig
	sed -e "s:-O2 -g:${CFLAGS}:" Makefile.orig > Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dobin stat
	doman stat.1
	dodoc COPYRIGHT GPL README Changelog
}
