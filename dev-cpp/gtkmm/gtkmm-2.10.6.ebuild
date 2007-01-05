# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm/gtkmm-2.10.6.ebuild,v 1.1 2007/01/05 13:14:26 remi Exp $

inherit gnome2 autotools

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sh ~sparc ~x86"
IUSE="accessibility doc examples"

RDEPEND=">=dev-cpp/glibmm-2.12.3
	>=x11-libs/gtk+-2.10.0
	>=dev-cpp/cairomm-1.1.12
	>=dev-libs/libsigc++-2.0
	accessibility? ( >=dev-libs/atk-1.9.1 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS CHANGES ChangeLog PORTING NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} \
			$(use_enable accessibility api-atkmm) \
			$(use_enable doc docs) \
			$(use_enable examples)
			$(use_enable examples demos)"
}
