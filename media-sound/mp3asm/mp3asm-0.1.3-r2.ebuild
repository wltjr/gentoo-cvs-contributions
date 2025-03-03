# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3asm/mp3asm-0.1.3-r2.ebuild,v 1.1 2006/03/21 09:49:57 sbriesen Exp $

inherit eutils toolchain-funcs

MY_PV="${PV}-1"  # Patchlevel

DESCRIPTION="A command line tool to clean and edit mp3 files."
HOMEPAGE="http://sourceforge.net/projects/mp3asm/"
SRC_URI="mirror://sourceforge/mp3asm/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""

# the author uses weird numbering...
S="${WORKDIR}/mp3asm-0.1"

src_compile() {
	econf || die "econf failed"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin src/mp3asm || die "install failed"
	dodoc Changelog README
}
