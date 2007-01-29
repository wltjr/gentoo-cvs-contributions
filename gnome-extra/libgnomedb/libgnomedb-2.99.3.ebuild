# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgnomedb/libgnomedb-2.99.3.ebuild,v 1.1 2007/01/29 22:53:46 leonardop Exp $

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.9"

inherit autotools eutils mono gnome2

DESCRIPTION="Database widget library from the GNOME-DB project"
HOMEPAGE="http://www.gnome-db.org/"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc mono"

# Dependencies here are set looking to obtain the most functionality, given that
# they are not unreasonable (e.g. gtk+'s version, gconf even if it's optional,
# etc.).
#
# There is no evolution-data-server support yet, only a check in configure.
RDEPEND=">=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2
	>=gnome-extra/libgda-2.99.2
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/libglade-2
	>=x11-libs/gtksourceview-1
	mono? (
		>=dev-lang/mono-1
		>=dev-dotnet/glade-sharp-2
		>=dev-dotnet/gnome-sharp-2
		>=dev-dotnet/gtk-sharp-2.3.90 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.28
	app-text/scrollkeeper
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS"


pkg_setup() {
	G2CONF="$(use_enable mono csharp)"

	if use mono && ! built_with_use libgda mono; then
		ewarn "The package gnome-extra/libgda has been installed without the"
		ewarn "'mono' USE flag. libgnomedb will be built without mono support."
	fi
}

src_unpack() {
	gnome2_src_unpack

	# Avoid file collisions with libgnomedb-1.2.x
	epatch "${FILESDIR}/${P}-collisions.patch"
	mv -f ${S}/control-center/database-properties.desktop.in ${S}/control-center/database-properties-3.0.desktop.in
	mv -f ${S}/data/libgnomedb.schemas.in ${S}/data/libgnomedb-3.0.schemas.in
	mv -f ${S}/doc/libgnomedb-C.omf.in ${S}/doc/libgnomedb-3.0-C.omf.in
	mv -f ${S}/doc/C/libgnomedb-docs.sgml ${S}/doc/C/libgnomedb-3.0-docs.sgml
	mv -f ${S}/doc/C/libgnomedb-overrides.txt ${S}/doc/C/libgnomedb-3.0-overrides.txt
	mv -f ${S}/doc/C/libgnomedb-sections.txt ${S}/doc/C/libgnomedb-3.0-sections.txt
	mv -f ${S}/doc/C/libgnomedb.types ${S}/doc/C/libgnomedb-3.0.types

	eautoreconf
}
