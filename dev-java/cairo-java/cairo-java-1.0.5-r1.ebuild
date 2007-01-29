# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/cairo-java/cairo-java-1.0.5-r1.ebuild,v 1.2 2007/01/29 09:30:42 opfer Exp $

inherit java-gnome

DESCRIPTION="Java bindings for cairo"

SLOT="1.0"
KEYWORDS="~amd64 ~ppc x86"

DEPS=">=x11-libs/cairo-1.0.0-r2
		>=dev-java/glib-java-0.2.2
		>=media-libs/fontconfig-2.3.1
		>=dev-libs/glib-2.6.0"
DEPEND="${DEPS}"
RDEPEND="${DEPS}"
