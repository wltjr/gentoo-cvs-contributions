# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat/xchat-2.8.4-r3.ebuild,v 1.2 2008/02/07 22:54:45 cla Exp $

inherit eutils versionator gnome2

DESCRIPTION="Graphical IRC client"
SRC_URI="http://www.xchat.org/files/source/$(get_version_component_range 1-2)/${P}.tar.bz2
	mirror://sourceforge/${PN}/${P}.tar.bz2
	xchatdccserver? ( mirror://gentoo/${PN}-dccserver-0.6.patch.bz2 )"
HOMEPAGE="http://www.xchat.org/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="perl dbus tcl python ssl mmx ipv6 libnotify nls spell xchatnogtk xchatdccserver"

RDEPEND=">=dev-libs/glib-2.6.0
	!xchatnogtk? ( >=x11-libs/gtk+-2.10.0 )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	perl? ( >=dev-lang/perl-5.6.1 )
	python? ( >=dev-lang/python-2.2 )
	tcl? ( dev-lang/tcl )
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	spell? ( app-text/enchant )
	libnotify? ( x11-libs/libnotify )
	!<net-irc/xchat-gnome-0.9"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	use xchatdccserver && epatch "${DISTDIR}"/xchat-dccserver-0.6.patch.bz2

	# use libdir/xchat/plugins as the plugin directory
	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e 's:${prefix}/lib/xchat:${libdir}/xchat:' \
			"${S}"/configure{,.in} || die
	fi

	epatch "${FILESDIR}"/xc284-scrollbmkdir.diff
	epatch "${FILESDIR}"/xc284-improvescrollback.diff
	epatch "${FILESDIR}"/xc284-fix-scrollbfdleak.diff
	epatch "${FILESDIR}"/xchat-fix-uk_UA-locale.diff
}

src_compile() {
	# Added for to fix a sparc seg fault issue by Jason Wever <weeve@gentoo.org>
	if [[ ${ARCH} = sparc ]] ; then
		replace-flags "-O[3-9]" "-O2"
	fi

	# xchat's configure script uses sys.path to find library path
	# instead of python-config (#25943)
	unset PYTHONPATH

	econf \
		--enable-shm \
		$(use_enable ssl openssl) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable tcl) \
		$(use_enable mmx) \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_enable dbus) \
		$(use_enable spell spell static) \
		$(use_enable !xchatnogtk gtkfe) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	USE_DESTDIR=1 gnome2_src_install || die "make install failed"

	# install plugin development header
	insinto /usr/include/xchat
	doins src/common/xchat-plugin.h || die "doins failed"

	dodoc ChangeLog README* || die "dodoc failed"
}

pkg_postinst() {
	elog
	elog "XChat binary has been renamed from xchat-2 to xchat."
	elog

	if has_version net-irc/xchat-systray
	then
		elog "XChat now includes it's own systray icon, you may want to remove net-irc/xchat-systray."
		elog
	fi
}
