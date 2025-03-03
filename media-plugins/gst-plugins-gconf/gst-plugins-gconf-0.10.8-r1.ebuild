# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gconf/gst-plugins-gconf-0.10.8-r1.ebuild,v 1.5 2008/07/31 18:45:27 armin76 Exp $

GCONF_DEBUG=no

inherit gnome2 gst-plugins-good gst-plugins10

KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ppc ppc64 ~sh sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=gnome-base/gconf-2
	>=media-libs/gstreamer-0.10.18
	>=media-libs/gst-plugins-base-0.10.18"

GST_PLUGINS_BUILD="gconf gconftool"

# override eclass
src_unpack() {
	unpack ${A}
}

src_compile() {
	gst-plugins-good_src_configure \
		--with-default-audiosink=autoaudiosink \
		--with-default-visualizer=goom

	gst-plugins10_find_plugin_dir
	emake || die "compile failure"

	cd "${S}"/gconf
	emake || die "compile failure"
}

src_install() {
	gst-plugins10_find_plugin_dir
	einstall || die

	cd "${S}"/gconf
	gnome2_src_install || die
}
