# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/monkey-bubble/monkey-bubble-0.3.2.ebuild,v 1.12 2006/05/01 07:02:31 mr_bones_ Exp $

inherit autotools eutils gnome2

DESCRIPTION="A Puzzle Bobble clone"
HOMEPAGE="http://home.gna.org/monkeybubble/"
SRC_URI="http://home.gna.org/monkeybubble/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	>=gnome-base/libglade-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/librsvg-2.0
	>=gnome-base/gconf-2.0
	=media-libs/gstreamer-0.8*
	>=dev-libs/libxml2-2.6.7
	app-text/scrollkeeper
	=media-libs/gst-plugins-0.8*"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch \
		"${FILESDIR}/${P}.amd64.patch" \
		"${FILESDIR}/${P}-asneeded.patch"
	eautoreconf
	sed -i \
		-e "s:-Werror::" \
		src/util/Makefile.in \
		src/input/Makefile.in \
		src/monkey/Makefile.in \
		src/view/Makefile.in \
		src/audio/Makefile.in \
		src/net/Makefile.in \
		src/net/Makefile.in \
		src/ui/Makefile.in \
		|| die "sed failed"
}
