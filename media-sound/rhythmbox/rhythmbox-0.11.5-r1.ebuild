# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rhythmbox/rhythmbox-0.11.5-r1.ebuild,v 1.2 2008/07/08 21:26:43 dang Exp $

EAPI="1"

inherit gnome2 eutils python autotools

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE="daap dbus doc hal ipod gnome-keyring libnotify lirc musicbrainz mtp python tagwriting"

# I want tagwriting to be on by default in the future. It is just a local flag
# now because it is still considered experimental by upstream and doesn't work
# well with all formats due to gstreamer limitation.

# FIXME: double check what to do with fm-radio plugin an itunes browser

SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.8
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=gnome-base/gnome-vfs-2.8
	>=dev-libs/totem-pl-parser-2.21.4
	>=gnome-extra/nautilus-cd-burner-2.13
	>=x11-libs/libsexy-0.1.5
	>=gnome-extra/gnome-media-2.14.0
	gnome-keyring? ( >=gnome-base/gnome-keyring-0.4.9 )
	musicbrainz? ( >=media-libs/musicbrainz-2.1:1 )
	>=net-libs/libsoup-2.4:2.4
	lirc? ( app-misc/lirc )
	hal? (
		ipod? ( >=media-libs/libgpod-0.4 )
		mtp? ( >=media-libs/libmtp-0.3.0 )
		>=sys-apps/hal-0.5
	)
	daap? ( >=net-dns/avahi-0.6 )
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	>=media-libs/gst-plugins-base-0.10.12
	>=media-plugins/gst-plugins-gnomevfs-0.10
	|| (
		>=media-plugins/gst-plugins-cdparanoia-0.10
		>=media-plugins/gst-plugins-cdio-0.10
		)
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	libnotify? ( >=x11-libs/libnotify-0.3.2 )
	tagwriting? ( >=media-plugins/gst-plugins-taglib-0.10.6 )
	python? (
		>=dev-lang/python-2.4.2
		>=dev-python/pygtk-2.8
		>=dev-python/gnome-python-2.12
		>=dev-python/gst-python-0.10.8
	)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	doc? ( >=dev-util/gtk-doc-1.4 )"

DOCS="AUTHORS ChangeLog DOCUMENTERS INTERNALS \
	  MAINTAINERS NEWS README README.iPod THANKS TODO"

pkg_setup() {

	if ! use hal && use ipod; then
		ewarn "ipod support requires hal support.  Please"
		ewarn "re-emerge with USE=hal to enable ipod support"
	fi

	if ! use hal && use mtp; then
		ewarn "MTP support requires hal support.  Please"
		ewarn "re-emerge with USE=hal to enable MTP support"
	fi

	if use daap ; then
		G2CONF="${G2CONF} --enable-daap --with-mdns=avahi"
	else
		G2CONF="${G2CONF} --disable-daap"
	fi

	G2CONF="${G2CONF}
		$(use_enable tagwriting tag-writing)
		$(use_with ipod)
		$(use_with mtp)
		$(use_enable ipod ipod-writing)
		$(use_enable musicbrainz)
		$(use_with dbus)
		$(use_enable python)
		$(use_enable libnotify)
		$(use_enable lirc)
		$(use_with gnome-keyring)
		--with-playback=gstreamer-0-10
		--with-cd-burning
		--enable-mmkeys
		--enable-audioscrobbler
		--enable-track-transfer
		--with-metadata-helper
		--disable-scrollkeeper
		--disable-schemas-install
		--disable-vala"

	export GST_INSPECT=/bin/true
}

src_unpack() {
	gnome2_src_unpack

	# backport from svn HEAD, 0.11.6 shouldn't need it
	epatch "${FILESDIR}/${PN}-0.11.5-fix_gtk_doc.patch"
	#Fix for libmtp-0.3.0 API change
	epatch "${FILESDIR}/${P}-libmtp-0.3.0-API.patch"
	eautomake

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_compile() {
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	use python && python_mod_optimize /usr/$(get_libdir)/rhythmbox/plugins

	ewarn
	ewarn "If ${PN} doesn't play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn

	elog "The aac flag has been removed from rhythmbox."
	elog "This is due to stabilization issues with any gst-bad plugins."
	elog "Please emerge gst-plugins-bad and gst-plugins-faad to be able to play m4a files"
	elog "See bug #159538 for more information"
}
pkg_postrm() {
	gnome2_pkg_postrm
	use python && python_mod_cleanup /usr/$(get_libdir)/rhythmbox/plugins
}
