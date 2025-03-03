# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/wtf/wtf-20080715.ebuild,v 1.1 2008/07/15 03:27:42 darkside Exp $

DESCRIPTION="translates acronyms for you"
HOMEPAGE="http://netbsd.org/"
SRC_URI="http://dev.gentooexperimental.org/~darkside/distfiles/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="!games-misc/bsd-games"
RDEPEND="${DEPEND}"

src_install() {
	dobin wtf || die "dogamesbin failed"
	doman wtf.6
	insinto /usr/share/misc
	doins acronyms* || die "doins failed"
	dodoc README
}
