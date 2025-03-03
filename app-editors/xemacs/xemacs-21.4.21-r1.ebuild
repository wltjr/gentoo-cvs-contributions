# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xemacs/xemacs-21.4.21-r1.ebuild,v 1.4 2008/06/14 08:32:40 ulm Exp $

# Note: xemacs currently does not work with a hardened profile. If you
# want to use xemacs on a hardened profile then compile with the
# -nopie flag in CFLAGS or help fix bug #75028.

export WANT_AUTOCONF="2.1"
inherit autotools eutils

DESCRIPTION="highly customizable open source text editor and application development system"
HOMEPAGE="http://www.xemacs.org/"
SRC_URI="http://ftp.xemacs.org/xemacs-21.4/${P}.tar.gz
	http://www.malfunction.de/afterstep/files/NeXT_XEmacs.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE="eolconv esd gif gpm pop postgres ldap xface nas dnd X jpeg tiff png mule motif freewnn canna xim athena neXt Xaw3d gdbm berkdb"

X_DEPEND="x11-libs/libXt x11-libs/libXmu x11-libs/libXext x11-misc/xbitmaps"

DEPEND="virtual/libc
	!virtual/xemacs
	berkdb? ( sys-libs/db )
	gdbm? ( >=sys-libs/gdbm-1.8.3 )
	>=sys-libs/zlib-1.1.4
	>=dev-libs/openssl-0.9.6
	>=media-libs/audiofile-0.2.3
	gpm? ( >=sys-libs/gpm-1.19.6 )
	postgres? ( >=virtual/postgresql-server-7.2 )
	ldap? ( net-nds/openldap )
	esd? ( media-sound/esound )
	nas? ( media-libs/nas )
	X? ( $X_DEPEND !Xaw3d? ( !neXt? ( x11-libs/libXaw ) ) )
	dnd? ( x11-libs/dnd )
	motif? ( >=x11-libs/openmotif-2.1.30 )
	athena? ( x11-libs/libXaw )
	Xaw3d? ( x11-libs/Xaw3d )
	neXt? ( x11-libs/neXtaw )
	xface? ( media-libs/compface )
	tiff? ( media-libs/tiff )
	png? ( =media-libs/libpng-1.2* )
	jpeg? ( media-libs/jpeg )
	canna? ( app-i18n/canna )
	!amd64? ( freewnn? ( app-i18n/freewnn ) )
	>=sys-libs/ncurses-5.2
	>=app-admin/eselect-emacs-1.2"

PDEPEND="app-xemacs/xemacs-base
	mule? ( app-xemacs/mule-base )"

PROVIDE="virtual/xemacs"

src_unpack() {
	unpack ${P}.tar.gz
	use neXt && unpack NeXT_XEmacs.tar.gz

	cd "${S}"
	epatch "${FILESDIR}"/xemacs-21.4.19-texi.patch

	# see bug 58350, 102540 and 143580
	epatch "${FILESDIR}"/xemacs-21.4.19-db.patch

	# Security bug #216880
	epatch "${FILESDIR}"/xemacs-21.4.21-vcdiff.patch

	# Run autoconf. XEmacs tries to be smart by providing a stub
	# configure.ac file for autoconf 2.59 but this throws our
	# autotools eclass so it must be removed first.
	rm "${S}"/configure.ac
	eautoconf

	use neXt && cp "${WORKDIR}"/NeXT.XEmacs/xemacs-icons/* "${S}"/etc/toolbar/
}

src_compile() {
	local myconf=""

	if use X; then

		myconf="${myconf} --with-widgets=athena"
		myconf="${myconf} --with-dialogs=athena"
		myconf="${myconf} --with-menubars=lucid"
		myconf="${myconf} --with-scrollbars=lucid"
		if use motif ; then
			myconf="--with-widgets=motif"
			myconf="${myconf} --with-dialogs=motif"
			myconf="${myconf} --with-scrollbars=motif"
			myconf="${myconf} --with-menubars=lucid"
		fi
		if use athena ; then
			myconf="--with-scrollbars=athena"
		fi

		if use Xaw3d; then
			myconf="${myconf} --with-athena=3d"
		elif use neXt; then
			myconf="${myconf} --with-athena=next"
		else
			myconf="${myconf} --with-athena=xaw"
		fi

		use dnd && myconf="${myconf} --with-dragndrop --with-offix"

		myconf="${myconf} $(use_with tiff ) $(use_with png )"
		myconf="${myconf} $(use_with jpeg ) $(use_with xface )"
	else
		myconf="${myconf}
			--without-x
			--without-xpm
			--without-dragndrop
			--with-gif=no"
	fi

	if use mule ; then
		myconf="${myconf} --with-mule"

		if use xim ; then
			if use motif ; then
				myconf="${myconf} --with-xim=motif"
			else
				myconf="${myconf} --with-xim=xlib"
			fi
		else
			myconf="${myconf} --with-xim=no"
		fi

		myconf="${myconf} $(use_with canna ) $(use_with freewnn wnn )"
	fi

	# This determines the type of sounds we are playing
	local soundconf="native"

	# This determines how these sounds should be played
	use nas	&& soundconf="${soundconf},nas"
	use esd && soundconf="${soundconf},esd"

	myconf="${myconf} --with-sound=${soundconf}"

	if use gdbm || use berkdb ; then
		use gdbm && mydb="gdbm"

		use berkdb && mydb="${mydb},berkdb"

		myconf="${myconf} --with-database=${mydb}"
	else
		myconf="${myconf} --without-database"
	fi

	# fixes #21264, this should be fixed in 21.4.21 and has been fixed
	# in 21.5 for sure. Now that 21.4.21 is out there is no real
	# evidence that this indeed got fixed, so keep these exceptions
	# for now.
	use alpha && myconf="${myconf} --with-system-malloc"
	use ppc64 && myconf="${myconf} --with-system-malloc"
	use ia64  && myconf="${myconf} --with-system-malloc"

	# Enabling modules will cause segfaults outside the XEmacs build directory
	use ia64  && myconf="${myconf} --without-modules"

	einfo "${myconf}"

	# Don't use econf because it uses options which this configure
	# script does not understand (like --host).
	./configure ${myconf} ${EXTRA_ECONF} \
		$(use_with gif ) \
		$(use_with gpm ) \
		$(use_with postgres postgresql ) \
		$(use_with ldap ) \
		$(use_with eolconv file-coding ) \
		$(use_with pop ) \
		--prefix=/usr \
		--with-ncurses \
		--with-msw=no \
		--mail-locking=flock \
		--with-site-lisp=yes \
		--with-site-modules=yes \
		|| die "The configure script failed to run properly"

	emake || die "emake failed"
}

src_install() {
	emake prefix="${D}"/usr \
		mandir="${D}"/usr/share/man/man1 \
		infodir="${D}"/usr/share/info \
		install gzip-el || die "emake install failed"

	# Rename some applications installed in bin so that it is clear
	# which application installed them and so that conflicting
	# packages (emacs) can't clobber the actual applications.
	# Addresses bug #62991.
	for i in b2m ctags etags rcs-checkin ; do
		mv "${D}"/usr/bin/${i} "${D}"/usr/bin/${i}-xemacs || die "mv ${i} failed"
	done

	# rename man pages
	for i in ctags etags; do
		mv "${D}"/usr/share/man/man1/${i}{,-xemacs}.1 || die "mv ${i}.1 failed"
	done

	# install base packages directories
	dodir /usr/lib/xemacs/xemacs-packages/
	dodir /usr/lib/xemacs/site-packages/
	dodir /usr/lib/xemacs/site-modules/
	dodir /usr/lib/xemacs/site-lisp/

	if use mule;
	then
		dodir /usr/lib/xemacs/mule-packages
	fi

	# remove extraneous info files
	cd "${D}"/usr/share/info
	rm -f dir info.info texinfo* termcap* standards*

	cd "${S}"
	dodoc BUGS CHANGES-* ChangeLog GETTING* INSTALL PROBLEMS README*
	dodoc "${FILESDIR}"/README.Gentoo

	insinto /usr/share/pixmaps
	newins "${S}"/etc/${PN}-icon.xpm ${PN}.xpm

	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop
}

pkg_postinst() {
	eselect emacs update ifunset
}

pkg_postrm() {
	eselect emacs update ifunset
}
