# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/ucon64/ucon64-1.9.8.4.ebuild,v 1.7 2007/03/12 18:23:00 genone Exp $

MAJ_PV=${PV:0:5}
MIN_PV=${PV:6:7}
MY_P="${PN}-${MAJ_PV}-${MIN_PV}-src"

DESCRIPTION="The backup tool and wonderful emulator's Swiss Army knife program"
HOMEPAGE="http://ucon64.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND="virtual/libc
	sys-libs/zlib"

S="${WORKDIR}/${MY_P}/src"

src_compile() {
	myconf=""
	if [[ ! -e /usr/include/sys/io.h ]] ; then
		ewarn "Disabling support for parallel port"
		myconf="${myconf} --disable-parallel"
	fi

	econf ${myconf} || die "configure failed"
	emake || die "build failed"
}

src_install() {
	dobin ucon64 || die "dobin failed"
	dolib.so libdiscmage/discmage.so || die "dolib.so failed"
	dodoc GoodCodes.txt || die "dodoc failed"
	dohtml -x src -r -A png,jpg ../ || die "dohtml failed"
}

pkg_postinst() {
	echo
	elog "In order to use ${PN}, please create the directory ~/.ucon64/dat"
	elog "The command to do that is:"
	elog "    mkdir -p ~/.ucon64/dat"
	elog "Then, you can copy your DAT file collection to ~/.ucon64/dat"
	elog
	elog "To enable Discmage support, cp /usr/lib/discmage.so to ~/.ucon64"
	elog "The command to do that is:"
	elog "    cp /usr/lib/discmage.so ~/.ucon64/"
	elog
	elog "Be sure to check ~/.ucon64rc for some options after"
	elog "you've run uCON64 for the first time"

}
