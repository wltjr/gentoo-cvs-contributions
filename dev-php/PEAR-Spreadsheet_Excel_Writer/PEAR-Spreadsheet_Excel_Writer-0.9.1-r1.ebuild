# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Spreadsheet_Excel_Writer/PEAR-Spreadsheet_Excel_Writer-0.9.1-r1.ebuild,v 1.8 2008/03/29 00:17:41 maekke Exp $

inherit php-pear-r1 eutils

DESCRIPTION="Package for generating Excel spreadsheets"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
RDEPEND=">=dev-php/PEAR-OLE-0.5-r1"
IUSE="unicode"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use unicode && epatch "${FILESDIR}"/${P}-utf8.patch
}
