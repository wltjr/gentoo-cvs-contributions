# Copyright 2000-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/avahi/avahi-0.6.22-r1.ebuild,v 1.9 2008/05/29 17:36:48 hawking Exp $

WANT_AUTOMAKE="1.9"
WANT_AUTOCONF="none"
EAPI="1"

inherit eutils mono python multilib autotools

DESCRIPTION="System which facilitates service discovery on a local network"
HOMEPAGE="http://avahi.org/"
SRC_URI="http://avahi.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="bookmarks howl-compat mdnsresponder-compat gdbm dbus doc mono gtk python qt3 qt4 autoipd kernel_linux test ipv6"

RDEPEND=">=dev-libs/libdaemon-0.11-r1
	dev-libs/expat
	>=dev-libs/glib-2
	gdbm? ( sys-libs/gdbm )
	qt3? ( x11-libs/qt:3 )
	qt4? (
		|| (
			x11-libs/qt-core:4
			x11-libs/qt:4
		)
	)
	gtk? (
		>=x11-libs/gtk+-2.4.0
		>=gnome-base/libglade-2.4.0
	)
	dbus? (
		>=sys-apps/dbus-0.30
		python? (
			|| (
				dev-python/dbus-python
				(
					<sys-apps/dbus-0.90
					>=sys-apps/dbus-0.30
				)
			)
		)
	)
	mono? (
		>=dev-lang/mono-1.1.10
		gtk? ( >=dev-dotnet/gtk-sharp-2 )
	)
	howl-compat? ( !net-misc/howl )
	mdnsresponder-compat? ( !net-misc/mDNSResponder )
	python? (
		>=virtual/python-2.4
		gtk? ( >=dev-python/pygtk-2 )
	)
	bookmarks? (
		dev-python/twisted
		dev-python/twisted-web
	)
	kernel_linux? ( sys-libs/libcap )
	!net-misc/mDNSResponder"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9.0
	doc? (
		app-doc/doxygen
		mono? ( >=dev-util/monodoc-1.1.8 )
	)"

pkg_setup() {
	if use python && ! built_with_use dev-lang/python gdbm
	then
		die "For python support you need dev-lang/python compiled with gdbm support!"
	fi

	if use python && use dbus && ! has_version dev-python/dbus-python && ! built_with_use sys-apps/dbus python
	then
		die "For python and dbus support you need sys-apps/dbus compiled with python support or dev-python/dbus-python!"
	fi

	if ( use mdnsresponder-compat || use howl-compat || use mono ) && ! use dbus
	then
		die "For *-compat or mono support you also need to enable the dbus USE flag!"
	fi

	if use bookmarks && ! ( use python && use dbus && use gtk )
	then
		die "For bookmarks support you also need to enable the python, dbus and gtk USE flags!"
	fi

	if use python && ! use dbus && ! use gtk
	then
		die "For proper python support you also need the dbus and gtk USE flags!"
	fi
}

pkg_preinst() {
	enewgroup netdev
	enewgroup avahi
	enewuser avahi -1 -1 -1 avahi

	if use autoipd
	then
		enewgroup avahi-autoipd
		enewuser avahi-autoipd -1 -1 -1 avahi-autoipd
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-vncviewer.patch
	epatch "${FILESDIR}"/${P}-gobject.patch

	eautomake

	use ipv6 && sed -i -e s/use-ipv6=no/use-ipv6=yes/ avahi-daemon/avahi-daemon.conf

	sed -i -e "s:\\.\\./\\.\\./\\.\\./doc/avahi-docs/html/:../../../doc/${PF}/html/:" doxygen_to_devhelp.xsl
}

src_compile() {
	local myconf=""

	if use python
	then
		use dbus && myconf="${myconf} --enable-python-dbus"
		use gtk && myconf="${myconf} --enable-pygtk"
	fi

	if use mono && use doc
	then
		myconf="${myconf} --enable-monodoc"
	fi

	# We need to unset DISPLAY, else the configure script might have problems detecting the pygtk module
	unset DISPLAY

	econf \
		--localstatedir=/var \
		--with-distro=gentoo \
		--disable-python-dbus \
		--disable-pygtk \
		--disable-xmltoman \
		--disable-monodoc \
		--enable-glib \
		$(use_enable test tests) \
		$(use_enable autoipd) \
		$(use_enable mdnsresponder-compat compat-libdns_sd) \
		$(use_enable howl-compat compat-howl) \
		$(use_enable doc doxygen-doc) \
		$(use_enable mono) \
		$(use_enable dbus) \
		$(use_enable python) \
		$(use_enable gtk) \
		$(use_enable qt3) \
		$(use_enable qt4) \
		$(use_enable gdbm) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"

	use doc && emake avahi.devhelp
}

src_install() {
	emake install py_compile=true DESTDIR="${D}" || die "make install failed"
	use bookmarks || rm -f "${D}"/usr/bin/avahi-bookmarks

	use howl-compat && ln -s avahi-compat-howl.pc "${D}"/usr/$(get_libdir)/pkgconfig/howl.pc
	use mdnsresponder-compat && ln -s avahi-compat-libdns_sd/dns_sd.h "${D}"/usr/include/dns_sd.h

	if use autoipd
	then
		insinto /$(get_libdir)/rcscripts/net
		doins "${FILESDIR}"/autoipd.sh

		insinto /$(get_libdir)/rc/net
		newins "${FILESDIR}"/autoipd-openrc.sh autoipd.sh
	fi

	dodoc docs/{AUTHORS,README,TODO}

	if use doc
	then
		dohtml -r doxygen/html/.
		insinto /usr/share/devhelp/books/avahi
		doins avahi.devhelp
	fi
}

pkg_postrm() {
	use python && python_mod_cleanup
}

pkg_postinst() {
	if use python; then
		python_version
		python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/avahi
	fi

	if use autoipd
	then
		elog
		elog "To use avahi-autoipd to configure your interfaces with IPv4LL (RFC3927)"
		elog "addresses, just set config_<interface>=( autoipd ) in /etc/conf.d/net!"
		elog
	fi

	if use dbus
	then
		elog
		elog "If this is your first install of avahi please reload your dbus config"
		elog "with /etc/init.d/dbus reload before starting avahi-daemon!"
		elog
	fi
}
