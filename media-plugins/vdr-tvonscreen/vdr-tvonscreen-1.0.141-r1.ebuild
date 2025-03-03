# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-tvonscreen/vdr-tvonscreen-1.0.141-r1.ebuild,v 1.2 2008/04/22 16:00:53 mr_bones_ Exp $

IUSE=""
inherit vdr-plugin

DESCRIPTION="VDR plugin: Show EPG like a TV guide"
HOMEPAGE="http://www.js-home.org/vdr/tvonscreen"
SRC_URI="http://www.js-home.org/vdr/tvonscreen/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=media-video/vdr-1.4.1"

PATCHES=("${FILESDIR}/${P}-fixes.diff"
	"${FILESDIR}/${P}-vdr-1.5.3.diff")

NO_GETTEXT_HACK=1
