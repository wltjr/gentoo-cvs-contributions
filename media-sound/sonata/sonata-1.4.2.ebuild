# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sonata/sonata-1.4.2.ebuild,v 1.5 2008/04/21 14:42:06 armin76 Exp $

inherit distutils

DESCRIPTION="an elegant GTK+ music client for the Music Player Daemon (MPD)."
HOMEPAGE="http://sonata.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="amd64 ~ppc64 ~sparc x86"
SLOT="0"
IUSE="taglib lyrics dbus"

RDEPEND=">=virtual/python-2.4
	>=dev-python/pygtk-2.10
	taglib? ( >=dev-python/tagpy-0.93 )
	dbus? ( dev-python/dbus-python )
	lyrics? ( dev-python/zsi )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if ! built_with_use '=x11-libs/gtk+-2*' jpeg; then
		ewarn "If you want album cover art displayed in Sonata,"
		ewarn "you must build gtk+-2 with the \"jpeg\" USE flag."
	fi
}

DOCS="CHANGELOG README TODO TRANSLATORS"
