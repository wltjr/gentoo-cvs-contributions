# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/luma/luma-1.4.ebuild,v 1.1 2004/08/20 00:09:26 carlo Exp $

DESCRIPTION="Luma is a graphical utility for accessing and managing data stored on LDAP servers."
HOMEPAGE="http://luma.sourceforge.net/"
SRC_URI="mirror://sourceforge/luma/${P}-r1.tar.bz2"

S=${WORKDIR}/${P}-r1

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="samba"

RDEPEND=">=x11-libs/qt-3.2
	>=dev-lang/python-2.3
	>=dev-python/PyQt-3.10
	>=dev-python/python-ldap-2.0.1
	samba? ( >=dev-python/py-smbpasswd-1.0 )"
DEPEND=">=x11-libs/qt-3.2
	>=dev-lang/python-2.3
	>=dev-python/PyQt-3.10
	>=dev-python/python-ldap-2.0.0_pre13
	samba? ( >=dev-python/py-smbpasswd-1.0 )"

src_install () {
	dodir /usr
	python install.py --prefix=${D}/usr
}
