# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ogle-gui/ogle-gui-0.9.1.ebuild,v 1.4 2003/12/13 21:28:58 seemant Exp $

IUSE="nls"

MY_P=${P/-/_}

S=${WORKDIR}/${MY_P}
DESCRIPTION="GUI interface for the Ogle DVD player."
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd"
SRC_URI="${HOMEPAGE}/dist/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc ~sparc ~alpha ~hppa ~mips ~arm amd64 ~ia64"

DEPEND=">=media-video/ogle-${PV}
	=x11-libs/gtk+-1.2*
	dev-libs/libxml2
	sys-devel/bison
	( >=gnome-base/libglade-0.17-r6
	<gnome-base/libglade-2.0.0 )"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {

	local myconf

	use nls || myconf="--disable-nls"

	libtoolize --copy --force

	# libxml2 hack
	CFLAGS="${CFLAGS} -I/usr/include/libxml2/libxml"

	econf ${myconf} || die
	emake || die

}

src_install() {

	einstall || die
	dodoc ABOUT-NLS AUTHORS COPYING INSTALL NEWS README
}
