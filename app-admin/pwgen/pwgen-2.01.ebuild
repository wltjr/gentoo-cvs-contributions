# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/pwgen/pwgen-2.01.ebuild,v 1.18 2004/06/06 11:24:07 dragonheart Exp $

DESCRIPTION="Password Generator"
SRC_URI="mirror://sourceforge/pwgen/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/pwgen/"

SLOT="0"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="x86 ppc sparc hppa ~alpha"

DEPEND="virtual/glibc"

src_compile() {
	# Fix the Makefile
	cp Makefile.in Makefile.in.new
	sed -e 's:$(prefix)/man/man1:$(mandir)/man1:g' \
		Makefile.in.new > Makefile.in

	econf --sysconfdir=/etc/pwgen || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
