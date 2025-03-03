# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gdm/gdm-2.20.7.ebuild,v 1.3 2008/07/30 21:57:47 ranger Exp $

inherit eutils pam gnome2

DESCRIPTION="GNOME Display Manager"
HOMEPAGE="http://www.gnome.org/projects/gdm/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE_LIBC="elibc_glibc"
IUSE="accessibility afs branding dmx ipv6 gnome-keyring pam remote selinux tcpd xinerama $IUSE_LIBC"

# Name of the tarball with gentoo specific files
GDM_EXTRA="${PN}-2.20.5-gentoo-files"

SRC_URI="${SRC_URI}
		 mirror://gentoo/${GDM_EXTRA}.tar.bz2
		 branding? ( mirror://gentoo/gentoo-gdm-theme-r3.tar.bz2 )"

RDEPEND="dev-libs/dbus-glib
		 >=dev-libs/glib-2.12
		 >=x11-libs/gtk+-2.6
		 >=x11-libs/pango-1.3
		 >=gnome-base/libglade-2
		 >=gnome-base/libgnomecanvas-2
		 >=gnome-base/librsvg-1.1.1
		 >=dev-libs/libxml2-2.4.12
		 >=media-libs/libart_lgpl-2.3.11
		 x11-libs/gksu
		 x11-libs/libXi
		 x11-libs/libXau
		 x11-libs/libX11
		 x11-libs/libXext
		 x11-apps/sessreg
		 x11-libs/libXdmcp
		 xinerama? ( x11-libs/libXinerama )
		 sys-auth/consolekit
		 accessibility? ( x11-libs/libXevie )
		 afs? ( net-fs/openafs sys-libs/lwp )
		 dmx? ( x11-libs/libdmx )
		 gnome-keyring? ( >=gnome-base/gnome-keyring-2.22 )
		 pam? (
			virtual/pam
			>=sys-auth/pambase-20080318
		 )
		 !pam? ( elibc_glibc? ( sys-apps/shadow ) )
		 remote? ( gnome-extra/zenity )
		 selinux? ( sys-libs/libselinux )
		 tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"
DEPEND="${RDEPEND}
		dmx? ( x11-proto/dmxproto )
		sys-devel/gettext
		x11-proto/inputproto
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19
		>=app-text/scrollkeeper-0.1.4
		>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-prefetch
		--sysconfdir=/etc/X11
		--localstatedir=/var
		--with-xdmcp=yes
		--with-pam-prefix=/etc
		--with-console-kit=yes
		$(use_enable accessibility xevie)
		$(use_enable ipv6)
		$(use_enable remote secureremote)
		$(use_with selinux)
		$(use_with tcpd tcp-wrappers)
		$(use_with xinerama)"

	if use dmx ; then
		G2CONF="${G2CONF} --with-dmx=yes"
	else
		G2CONF="${G2CONF} --with-dmx=no"
	fi

	if use gnome-keyring && ! built_with_use gnome-base/gnome-keyring pam; then
		eerror "You need to build gnome-base/gnome-keyring with USE=\"pam\""
		eerror "for USE=\"gnome-keyring\" to have any effect on this package."
	fi

	if use pam; then
		G2CONF="${G2CONF} --enable-authentication-scheme=pam"

		if use gnome-keyring && ! built_with_use sys-auth/pambase gnome-keyring; then
			eerror "You need USE=\"gnome\" in sys-auth/pambase for proper keyring"
			eerror "unlocking at login time. It will not work properly otherwise."
		fi
	else
		G2CONF="${G2CONF} --enable-console-helper=no"
		if use elibc_glibc ; then
			G2CONF="${G2CONF} --enable-authentication-scheme=shadow"
		else
			G2CONF="${G2CONF} --enable-authentication-scheme=crypt"
		fi
	fi

	enewgroup gdm
	enewuser gdm -1 -1 /var/lib/gdm gdm
}

src_unpack() {
	gnome2_src_unpack

	# remove unneeded linker directive for selinux (#41022)
	epatch "${FILESDIR}/${PN}-2.13.0.1-selinux-remove-attr.patch"

	# Add gksu to gdmsetup menu entry
	epatch "${FILESDIR}/${PN}-2.20.2-gksu.patch"
}

src_install() {
	gnome2_src_install

	local gentoodir="${WORKDIR}/${GDM_EXTRA}"

	# gdm-binary should be gdm to work with our init (#5598)
	rm -f "${D}/usr/sbin/gdm"
	dosym /usr/sbin/gdm-binary /usr/sbin/gdm

	# our x11's scripts point to /usr/bin/gdm
	dosym /usr/sbin/gdm-binary /usr/bin/gdm

	# log, etc.
	keepdir /var/log/gdm
	keepdir /var/gdm

	fowners root:gdm /var/gdm
	fperms 1770 /var/gdm

	# use our own session script
	rm -f "${D}/etc/X11/gdm/Xsession"
	exeinto /etc/X11/gdm
	doexe "${gentoodir}/Xsession"

	# add a custom xsession .desktop by default (#44537)
	exeinto /etc/X11/dm/Sessions
	doexe "${gentoodir}/custom.desktop"

	# avoid file collision, bug #213118
	rm -f "${D}/usr/share/xsessions/gnome.desktop"

	# We replace the pam stuff by our own
	rm -rf "${D}/etc/pam.d"

	if use pam ; then
		use gnome-keyring && sed -i "s:#Keyring=::g" "${gentoodir}"/pam.d/*

		dopamd "${gentoodir}"/pam.d/*
		dopamsecurity console.apps "${gentoodir}/security/console.apps/gdmsetup"
	fi

	# use graphical greeter local
	dosed "s:#Greeter=/usr/libexec/gdmlogin:Greeter=/usr/libexec/gdmgreeter:" \
		/usr/share/gdm/defaults.conf

	# list available users
	dosed "s:^#MinimalUID=.*:MinimalUID=1000:" /usr/share/gdm/defaults.conf
	dosed "s:^#IncludeAll=.*:IncludeAll=true:" /usr/share/gdm/defaults.conf

	# Fix old X11R6 paths
	dosed "s:/usr/X11R6/bin:/usr/bin:" /usr/share/gdm/defaults.conf

	# Move Gentoo theme in
	if use branding ; then
		mv "${WORKDIR}"/gentoo-*  "${D}/usr/share/gdm/themes"
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To make GDM start at boot, edit /etc/conf.d/xdm"
	elog "and then execute 'rc-update add xdm default'."

	elog "GDM has changed the location of its configuration file.  Please"
	elog "edit /etc/X11/gdm/custom.conf.  The factory defaults are located"
	elog "at /usr/share/gdm/{defaults.conf,factory-defaults.conf}"

	elog "See README.install for more information about the change."

	if use gnome-keyring; then
		elog "For autologin to unlock your keyring, you need to set an empty"
		elog "password on your keyring. Use app-crypt/seahorse for that."
	fi

	if [ -f "/etc/X11/gdm/gdm.conf" ]; then
		elog "You had /etc/X11/gdm/gdm.conf which is the old configuration"
		elog "file.  It has been moved to /etc/X11/gdm/gdm-pre-gnome-2.16"
		mv /etc/X11/gdm/gdm.conf /etc/X11/gdm/gdm-pre-gnome-2.16
	fi

	# Soft restart, assumes Gentoo defaults for file locations
	# Do restart after gdm.conf move above
	FIFOFILE=/var/gdm/.gdmfifo
	PIDFILE=/var/run/gdm.pid

	if [ -w ${FIFOFILE} ] ; then
		if [ -f ${PIDFILE} ] ; then
			if kill -0 `cat ${PIDFILE}`; then
				(echo;echo SOFT_RESTART) >> ${FIFOFILE}
			fi
		fi
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ "$(rc-config list default | grep xdm)" != "" ]] ; then
		elog "To remove GDM from startup please execute"
		elog "'rc-update del xdm default'"
	fi
}
