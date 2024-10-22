# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cvoicecontrol/cvoicecontrol-0.9_alpha-r1.ebuild,v 1.2 2007/07/29 20:46:15 drac Exp $

inherit eutils

MY_P=${P/_/}

DESCRIPTION="Console based speech recognition system"
HOMEPAGE="http://www.kiecza.net/daniel/linux"
SRC_URI="http://www.kiecza.net/daniel/linux/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo-2.patch
	sed -i -e "s/install-data-am: install-data-local/install-data-am:/" Makefile.in

	# Handle documentation with dohtml instead.
	sed -i -e "s:SUBDIRS = docs:#SUBDIRS = docs:" cvoicecontrol/Makefile.in

}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS BUGS ChangeLog FAQ README
	dohtml cvoicecontrol/docs/en/*.html
}
