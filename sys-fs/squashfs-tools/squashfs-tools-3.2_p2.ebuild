# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/squashfs-tools/squashfs-tools-3.2_p2.ebuild,v 1.3 2008/06/28 09:13:48 wolf31o2 Exp $

inherit toolchain-funcs

MY_PV=${PV/_p/-r}
DESCRIPTION="Tool for creating compressed filesystem type squashfs"
HOMEPAGE="http://squashfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/squashfs/squashfs${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="sys-libs/zlib"

S=${WORKDIR}/squashfs${PV/_p/-r}/squashfs-tools

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s:-O2:${CFLAGS}:" Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin mksquashfs unsquashfs || die
	cd ..
	dodoc README ACKNOWLEDGEMENTS CHANGES PERFORMANCE.README README-3.2
}
