# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/dolphin/dolphin-0.8.2-r1.ebuild,v 1.1 2007/03/10 23:22:09 troll Exp $

inherit kde

DESCRIPTION="A file manager for KDE focusing on usability."
HOMEPAGE="http://enzosworld.gmxhome.de/"
SRC_URI="http://enzosworld.gmxhome.de/download/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

SLOT="0"
LICENSE="GPL-2"
IUSE="kdeenablefinal"

need-kde 3.5

PATCHES="${FILESDIR}/${P}-tarZip-handlers.patch"
