# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/gurlchecker/gurlchecker-0.8.2.ebuild,v 1.4 2006/10/31 22:10:29 leonardop Exp $

inherit gnome2

DESCRIPTION="Gnome tool that checks links on web pages/sites"
HOMEPAGE="http://gurlchecker.labs.libre-entreprise.org/"
SRC_URI="http://labs.libre-entreprise.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="ppc x86"
SLOT="0"
IUSE="doc gnutls"

RDEPEND=">=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=dev-libs/libxml2-2.6
	>=net-libs/gnet-2
	gnutls? ( >=net-libs/gnutls-1 )"

# docbook-sgml-utils used to build the man page
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.30
	app-text/docbook-sgml-utils
	doc? ( >dev-util/gtk-doc-1.1 )"

DOCS="ABOUT-NLS AUTHORS ChangeLog FAQ NEWS README THANKS TODO"

G2CONF="${G2CONF} $(use_with gnutls)"

src_unpack() {
	unpack ${A}
	# The file index.sgml should be distributed with the sources, but
	# it is not, causing problems. See bug #92784.
	touch ${S}/doc/html/index.sgml
}
