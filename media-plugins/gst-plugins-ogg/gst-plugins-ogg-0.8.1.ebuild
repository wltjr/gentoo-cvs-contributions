# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ogg/gst-plugins-ogg-0.8.1.ebuild,v 1.1 2004/04/23 17:37:18 foser Exp $

inherit gst-plugins

KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~hppa ~alpha ~ia64"

IUSE=""
RDEPEND=">=media-libs/libogg-1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

