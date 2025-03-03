# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cutils/cutils-1.6-r2.ebuild,v 1.6 2007/03/05 03:40:57 genone Exp $

inherit eutils

DESCRIPTION="C language utilities"
HOMEPAGE="http://www.sigala.it/sandro/software.php#cutils"
SRC_URI="http://www.sigala.it/sandro/files/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="ppc sparc x86 ~amd64"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack  ${A}
	epatch ${FILESDIR}/${P}-r1-gentoo.diff
	cd ${S}/src/cdecl
	mv cdecl.1 cutils-cdecl.1
	for file in ${S}/doc/*; do
		sed -e 's/cdecl/cutils-cdecl/g' -i ${file}
	done
	sed -e 's/Xr cdecl/Xr cutils-cdecl/' -i ${S}/src/cundecl/cundecl.1
}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=${DESTTREE} \
		--infodir=${DESTTREE}/share/info \
		--mandir=${DESTTREE}/share/man || die

	emake -j1 || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc COPYRIGHT CREDITS HISTORY INSTALL NEWS README
}

pkg_postinst () {
	elog "cdecl was installed as cutils-cdecl because of a naming conflict with dev-util/cdecl"
}
