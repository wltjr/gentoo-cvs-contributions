# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mawk/mawk-1.3.3.ebuild,v 1.12 2006/06/28 18:17:25 gustavoz Exp $

DESCRIPTION="an (often faster than gawk) awk-interpreter"
SRC_URI="ftp://ftp.whidbey.net/pub/brennan/${P}.tar.gz"
HOMEPAGE="http://freshmeat.net/projects/mawk/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ppc sparc ~alpha ~hppa ia64"

DEPEND="virtual/libc"
IUSE=""

src_compile() {
	export MATHLIB="-lm"

	./configure --prefix=/usr || die "Failed to configure"
	emake -j1 || die "Make failed"
}

src_install () {
	dodir /usr/bin /usr/share/man/man1
	make BINDIR=${D}/usr/bin \
	     MANDIR=${D}/usr/share/man/man1 \
	     install || die "Install failed"
	dodoc ACKNOWLEDGMENT CHANGES COPYING INSTALL README
}
