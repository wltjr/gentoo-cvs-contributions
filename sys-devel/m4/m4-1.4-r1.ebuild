# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/m4/m4-1.4-r1.ebuild,v 1.10 2004/06/24 22:47:44 agriffis Exp $

inherit eutils gnuconfig

PVER="17"
DESCRIPTION="GNU macro processor"
HOMEPAGE="http://www.gnu.org/software/m4/m4.html"
SRC_URI="ftp://ftp.seindal.dk/gnu/${P}.tar.gz
	mirror://gentoo/m4_1.4-${PVER}.diff.gz
	http://ftp.debian.org/debian/pool/main/m/m4/m4_1.4-${PVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc64 ppc sparc mips alpha arm hppa amd64 ia64 s390"
IUSE="nls"

DEPEND="virtual/glibc
	!bootstrap? ( >=sys-devel/libtool-1.3.5-r2 )
	nls? ( sys-devel/gettext )"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${DISTDIR}/${PN}_1.4-${PVER}.diff.gz

	use alpha && gnuconfig_update
}

src_compile() {
	local myconf=

	use nls || myconf="--disable-nls"

	./configure --host=${CHOST} \
		--prefix=/usr \
		--enable-changeword \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
		libexecdir=${D}/usr/lib \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die

#	rm -rf ${D}/usr/include

	dodoc BACKLOG ChangeLog NEWS README* THANKS TODO
}
