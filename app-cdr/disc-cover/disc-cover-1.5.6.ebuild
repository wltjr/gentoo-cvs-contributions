# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/disc-cover/disc-cover-1.5.6.ebuild,v 1.5 2007/04/28 16:16:42 armin76 Exp $

DESCRIPTION="Creates CD-Covers via Latex by fetching cd-info from freedb.org or local file."
HOMEPAGE="http://www.vanhemert.co.uk/disc-cover.html"
SRC_URI="http://www.vanhemert.co.uk/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE="cdrom"

SLOT="0"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	virtual/tetex
	cdrom? ( dev-perl/Audio-CD-disc-cover )"

src_compile() {
	pod2man disc-cover > disc-cover.1 || die
}

src_install() {
	dobin disc-cover
	dodoc AUTHORS CHANGELOG TODO
	doman disc-cover.1
	insinto /usr/share/${PN}/templates
	doins templates/*
}
