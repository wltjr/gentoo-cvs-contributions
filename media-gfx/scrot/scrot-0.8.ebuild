# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/scrot/scrot-0.8.ebuild,v 1.18 2007/03/19 17:15:05 drac Exp $

inherit bash-completion

DESCRIPTION="Screen capture utility using imlib2 library"
HOMEPAGE="http://www.linuxbrit.co.uk/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="as-is BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=media-libs/imlib2-1.0.3
	>=media-libs/giblib-1.2.3"

src_install() {
	emake DESTDIR="${D}" install || die
	rm -r "${D}"/usr/doc
	dodoc AUTHORS ChangeLog

	dobashcompletion ${FILESDIR}/${PN}.bash-completion ${PN}
}
