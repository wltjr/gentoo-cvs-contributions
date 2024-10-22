# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/lohit-fonts/lohit-fonts-2.1.9.ebuild,v 1.1 2008/03/03 03:56:22 dirtyepic Exp $

inherit font

FONT_S="${S}"
FONTDIR="/usr/share/fonts/indic"
FONT_SUFFIX="ttf"

DESCRIPTION="The Lohit family of indic fonts"
HOMEPAGE="http://fedoraproject.org/wiki/Lohit"
LICENSE="GPL-2"
SRC_URI="mirror://gentoo/${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DOCS="AUTHORS ChangeLog"

src_compile() {
	find ./ -name '*ttf' -exec  cp {} . \;
}
