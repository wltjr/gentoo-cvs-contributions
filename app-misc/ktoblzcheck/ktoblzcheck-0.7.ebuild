# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ktoblzcheck/ktoblzcheck-0.7.ebuild,v 1.8 2005/01/01 15:09:54 eradicator Exp $

DESCRIPTION="Library to check account numbers and bank codes of German banks"
HOMEPAGE="http://ktoblzcheck.sourceforge.net/"
SRC_URI="mirror://sourceforge/ktoblzcheck/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	sys-apps/gawk
	sys-apps/grep
	sys-devel/libtool
	sys-devel/gcc"

src_install() {
	emake DESTDIR=${D} || die "install failed"
}

src_test() {
	cd src/bin
	./check_ktoblzcheck || die "self check of accounts failed"
}
