# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/gftp/gftp-2.0.13.ebuild,v 1.6 2003/02/13 14:03:48 vapier Exp $

IUSE="nls gtk2"

S=${WORKDIR}/${P}
DESCRIPTION="Gnome based FTP Client"
SRC_URI="http://www.gftp.org/${P}.tar.gz"
HOMEPAGE="http://www.gftp.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

# very generic depends. it should be that way.
DEPEND="virtual/x11
	gtk2? ( >=x11-libs/gtk+-2.0.0 )"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls || myconf="--disable-nls"
	use gtk2 && myconf="${myconf} --enable-gtk20" 

	econf ${myconf} || die
	emake || die
}

src_install() {

	einstall || die

	dodoc COPYING ChangeLog README* THANKS TODO
	dodoc docs/USERS-GUIDE

}
