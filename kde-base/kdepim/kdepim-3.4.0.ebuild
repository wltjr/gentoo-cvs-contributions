# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.4.0.ebuild,v 1.2 2005/03/18 17:29:09 morfic Exp $

inherit kde-dist eutils

DESCRIPTION="KDE PIM (Personal Information Management) apps: korganizer, kmail, knode..."

KEYWORDS="~x86 ~amd64 ~sparc ~ppc"
IUSE="crypt gnokii pda"

DEPEND="~kde-base/kdebase-${PV}
	>=dev-libs/cyrus-sasl-2
	pda? ( app-pda/pilot-link dev-libs/libmal )
	gnokii? ( net-dialup/gnokii )
	crypt? ( >=app-crypt/gpgme-0.9.0-r1 )
	!net-www/akregator"

src_unpack() {
	kde_src_unpack

	# Applied for 3.4.1.
	cd "${S}/kresources/kolab/"
	epatch "${FILESDIR}/${P}-fix-imap-resource-type.patch"
	cd "${S}"
}

src_compile() {
	# needed to detect pi-notepad.h, used by the kpilot notepad conduit.
	use pda && myconf="${myconf} --with-extra-includes=/usr/include/libpisock"

	kde_src_compile
}
