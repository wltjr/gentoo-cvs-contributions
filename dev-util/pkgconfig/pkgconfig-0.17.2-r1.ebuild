# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkgconfig/pkgconfig-0.17.2-r1.ebuild,v 1.11 2007/02/28 22:09:45 genstef Exp $

inherit flag-o-matic gnome.org

DESCRIPTION="Package config system that manages compile/link flags for libraries"
HOMEPAGE="http://pkgconfig.freedesktop.org/wiki/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="hardened"

DEPEND=""

src_unpack() {
	unpack ${A}
	use ppc64 && use hardened && replace-flags -O[2-3] -O1
}

src_compile() {
	local myconf="--enable-indirect-deps"

	econf ${myconf} || die "./configure step failed"
	emake || die "Compilation failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
