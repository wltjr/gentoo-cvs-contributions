# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython-demo/wxpython-demo-2.4.2.4.ebuild,v 1.1 2003/10/08 17:41:59 pythonhead Exp $

# NOTE: rename DOCDIR to "wxpython" (lowercase) when dev-python/wxPython is renamed

MY_P=${P/wxpython-demo/wxPythonDemo}
DOCDIR="wxPython-${PVR}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="wxPython demo files"
HOMEPAGE="http://www.wxpython.org"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""


src_install() {
	dodir /usr/share/doc/${DOCDIR}
	dodir /usr/share/doc/${DOCDIR}/demo
	dodir /usr/share/doc/${DOCDIR}/samples
	cp -R ${WORKDIR}/${DOCDIR}/demo/* ${D}/usr/share/doc/${DOCDIR}/demo/
	cp -R ${WORKDIR}/${DOCDIR}/samples/* ${D}/usr/share/doc/${DOCDIR}/samples/
}

