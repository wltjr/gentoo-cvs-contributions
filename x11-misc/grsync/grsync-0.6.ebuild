# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/grsync/grsync-0.6.ebuild,v 1.3 2008/01/22 15:55:41 dertobi123 Exp $

inherit eutils gnome2 autotools

DESCRIPTION="A gtk frontend to rsync"
HOMEPAGE="http://www.opbyte.it/grsync/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86 ~x86-fbsd"
IUSE="doc"
SRC_URI="http://www.opbyte.it/release/${P}.tar.gz"

RDEPEND=">=x11-libs/gtk+-2.6
	net-misc/rsync"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS NEWS README"
