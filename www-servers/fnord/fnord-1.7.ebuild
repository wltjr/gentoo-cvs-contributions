# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/fnord/fnord-1.7.ebuild,v 1.4 2005/03/03 18:48:54 ciaranm Exp $

inherit eutils

DESCRIPTION="Yet another small httpd."
SRC_URI="http://www.fefe.de/fnord/${P}.tar.bz2"
HOMEPAGE="http://www.fefe.de/fnord/"

KEYWORDS="x86 sparc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="dev-libs/dietlibc"
RDEPEND="sys-process/daemontools"
IUSE=""

pkg_setup() {

	if ! grep -q ^fnord: /etc/passwd ; then
	    useradd  -g nofiles -s /bin/false -d /etc/fnord -c "fnord" fnord\
			|| die "problem adding user fnord"
	fi
	if ! grep -q ^fnordlog: /etc/passwd ; then
	    useradd  -g nofiles -s /bin/false -d /etc/fnord -c "fnordlog" fnordlog\
			|| die "problem adding user fnordlog"
	fi
}

src_unpack() {

	unpack ${A} ; cd ${S}
	mv Makefile Makefile.orig
	sed -e "s:^CFLAGS=-O.*:CFLAGS=${CFLAGS}:" \
		Makefile.orig > Makefile

	epatch ${FILESDIR}/${PF}-gentoo.diff || die "epatch failed."

}

src_compile() {

	emake || die

}

src_install () {

	exeinto /usr/bin
	doexe fnord-conf fnord

	dodoc TODO README SPEED COPYING CHANGES

}
