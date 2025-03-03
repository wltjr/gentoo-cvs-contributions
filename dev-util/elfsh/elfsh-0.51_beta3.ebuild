# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/elfsh/elfsh-0.51_beta3.ebuild,v 1.5 2007/01/06 23:00:43 malc Exp $

inherit eutils

MY_PV=${PV/_beta/b}
S=${WORKDIR}/${PN}-${MY_PV}
DESCRIPTION="scripting language to modify ELF binaries"
HOMEPAGE="http://elfsh.segfault.net/"
SRC_URI="mirror://gentoo/elfsh-${MY_PV}-portable.tgz"
#http://elfsh.segfault.net/files/elfsh-${MY_PV}-portable.tgz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=dev-libs/expat-1.95"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	sed -i \
		-e "s:-g3 -O2:${CFLAGS}:" \
		`find -name Makefile` \
		|| die
	sed -i -e "s:LIBPATH = \$(PREFIX)/lib:LIBPATH = \$(PREFIX)/$(get_libdir):" Makefile

}

src_compile() {
	# emacs does not have to be a requirement.
	emake ETAGS=echo || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "einstall failed"
}
