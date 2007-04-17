# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xcb-util/xcb-util-0.1_p20061216.ebuild,v 1.12 2007/04/17 19:23:34 dberkholz Exp $

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X C-language Bindings sample implementations"
HOMEPAGE="http://xcb.freedesktop.org/"
SRC_URI="http://dev.gentoo.org/~joshuabaergen/distfiles/${P}.tar.bz2"

LICENSE="X11"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"

RDEPEND="x11-libs/libxcb"
DEPEND="${RDEPEND}
	dev-util/gperf
	x11-proto/xproto"
