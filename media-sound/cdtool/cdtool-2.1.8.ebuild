# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdtool/cdtool-2.1.8.ebuild,v 1.5 2007/12/12 15:45:38 fmccor Exp $

DESCRIPTION="Collection of command-line utilities to control cdrom devices."
HOMEPAGE="http://hinterhof.net/cdtool"
SRC_URI="http://hinterhof.net/cdtool/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="!media-sound/cdplay"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc CHANGES CREDITS README TODO
}
