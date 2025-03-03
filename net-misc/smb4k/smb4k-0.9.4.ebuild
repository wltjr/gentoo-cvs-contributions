# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/smb4k/smb4k-0.9.4.ebuild,v 1.1 2008/05/17 17:05:07 carlo Exp $

ARTS_REQUIRED="never"

EAPI="1"

inherit kde

DESCRIPTION="Smb4K is a SMB share browser for KDE."
HOMEPAGE="http://smb4k.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bindist"

DEPEND="|| ( kde-base/konqueror:3.5 kde-base/kdebase:3.5 )"
RDEPEND="${DEPEND}
	bindist? ( <net-fs/samba-3.2.0_pre2 )
	!bindist? ( net-fs/samba )
	net-fs/mount-cifs"
need-kde 3.5
