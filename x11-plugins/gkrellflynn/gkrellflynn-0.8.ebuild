# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellflynn/gkrellflynn-0.8.ebuild,v 1.8 2007/07/11 20:39:23 mr_bones_ Exp $

inherit gkrellm-plugin

IUSE=""
HOMEPAGE="http://horus.comlab.uni-rostock.de/flynn/"
SRC_URI="http://horus.comlab.uni-rostock.de/flynn/${P}.tar.gz"
DESCRIPTION="A funny GKrellM2 load monitor (for Doom(tm) fans)"
KEYWORDS="alpha amd64 ppc sparc x86"
SLOT="0"
LICENSE="GPL-2"

src_compile() {
	make gkrellm2
}
