# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-doc/howto-html/howto-html-20010701.ebuild,v 1.5 2001/08/02 20:41:40 danarmak Exp $

P="Linux-html-HOWTOs"
S=${WORKDIR}/${P}

DESCRIPTION="The LDP howtos, html format."

SRC_URI="http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html/${P}-${PV}.tar.gz"

HOMEPAGE="http://www.linuxdoc.org"

src_install () {
    
    dodir /usr/share/doc/howto
    dodir /usr/share/doc/howto/html
    dosym /usr/share/doc/howto /usr/share/doc/HOWTO
    
    cd ${WORKDIR}
    insinto /usr/share/doc/howto/html
    doins *
    
}