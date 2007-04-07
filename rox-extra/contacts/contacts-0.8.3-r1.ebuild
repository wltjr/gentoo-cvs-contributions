# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-extra/contacts/contacts-0.8.3-r1.ebuild,v 1.3 2007/04/07 13:04:52 dertobi123 Exp $

ROX_LIB_VER=1.9.17
inherit rox

DESCRIPTION="Contacts - The ROX Contact Manager"
MY_PN="Contacts"
HOMEPAGE="http://roxos.sunsite.dk/dev-contrib/guido/Contacts/"
SRC_URI="http://roxos.sunsite.dk/dev-contrib/guido/Contacts/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

APPNAME=${MY_PN}
APPCATEGORY="Office;ContactManagement"
S=${WORKDIR}

