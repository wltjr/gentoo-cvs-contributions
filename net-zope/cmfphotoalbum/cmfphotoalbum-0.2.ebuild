# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/cmfphotoalbum/cmfphotoalbum-0.2.ebuild,v 1.5 2004/04/05 08:42:12 mr_bones_ Exp $

inherit zproduct

DESCRIPTION="Zope/CMF product to organize e-pics into hierarchical photo album."
HOMEPAGE="http://sourceforge.net/projects/collective/"
SRC_URI="mirror://sourceforge/collective/CMFPhotoAlbum-${PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
RDEPEND="=net-zope/cmfphoto-${PV}
	    >=net-zope/btreefolder2-0.5.0
	    ${RDEPEND}"

ZPROD_LIST="CMFPhotoAlbum"

pkg_postinst()
{
	zproduct_pkg_postinst
	ewarn "Please use CMFQuickInstallerTool or read the documentation of this"
	ewarn "product for instruction on how to add this product to your CMF/Plone site."
}
