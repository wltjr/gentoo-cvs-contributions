# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Philippe Namias <pnamias@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdetoys/kdetoys-2.2.1.ebuild,v 1.2 2001/09/19 18:56:33 danarmak Exp $

S=${WORKDIR}/${P}
DESCRIPTION="KDE ${PV} - Toys"
SRC_PATH="kde/stable/${PV}/src/${P}.tar.bz2"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"

HOMEPAGE="http://www.kde.org/"

DEPEND=">=kde-base/kdelibs-${PV}
	objprelink? ( dev-util/objprelink )"

RDEPEND="$DEPEND"

src_unpack() {

	cd ${WORKDIR}
	unpack ${P}.tar.bz2

}

src_compile() {

 	if [ "`use objprelink`" ] ; then
	  myconf="--enable-objprelink"
	fi
    ./configure --host=${CHOST} \
                --with-xinerama $myconf || die
    make || die
}

src_install() {
  make install DESTDIR=${D} || die
  dodoc AUTHORS COPYING README
}
