# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ryan Tolboom <ryan@intphsys.com>
# $Header: /var/cvsroot/gentoo-x86/net-www/links/links-0.95-r1.ebuild,v 1.4 2001/08/31 03:23:39 pm Exp $


S=${WORKDIR}/links-0.95
SRC_URI="http://artax.karlin.mff.cuni.cz/~mikulas/links/download/links-0.95.tar.gz"

HOMEPAGE="http://artax.karlin.mff.cuni.cz/~mikulas/links"

DESCRIPTION="A links like console-based web browser"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
        >=sys-libs/gpm-1.19.3
	ssl? ( >=dev-libs/openssl-0.9.6 )"

src_compile() {
    local myconf
    if [ "`use ssl` " ]
    then
        myconf="--enable-ssl"
    else
	myconf="--disable-ssl"
    fi
    try ./configure --prefix=/usr --mandir=/usr/share/man ${myconf}
    try make

}


src_install() {

    try make DESTDIR=${D} install

    dodoc README SITES NEWS AUTHORS COPYING BUGS TODO

}
