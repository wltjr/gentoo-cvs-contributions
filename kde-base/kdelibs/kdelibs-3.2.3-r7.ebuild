# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-3.2.3-r7.ebuild,v 1.7 2005/07/08 20:35:36 danarmak Exp $

inherit kde eutils

need-autoconf 2.5
set-kdedir ${PV}

DESCRIPTION="KDE libraries needed by all kde programs"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/stable/${PV}/src/${PN}-${PV}.tar.bz2
	mirror://kde/security_patches/post-3.2.3-kdelibs-kcookiejar.patch
	mirror://kde/security_patches/post-3.2.3-kdelibs-kstandarddirs.patch
	mirror://kde/security_patches/post-3.2.3-kdelibs-htmlframes2.patch
	mirror://kde/security_patches/post-3.2.3-kdelibs-kio.diff
	mirror://kde/security_patches/post-3.2.3-kdelibs-dcopserver.patch
	mirror://kde/security_patches/post-3.2.3-kdelibs-kioslave.patch"

LICENSE="GPL-2 LGPL-2"
SLOT="3.2"
KEYWORDS="alpha amd64 hppa ~ia64 ~mips ppc sparc x86"
IUSE="alsa cups ipv6 ssl doc ldap"

# kde.eclass has kdelibs in DEPEND, and we can't have that in here.
# so we recreate the entire DEPEND from scratch.
DEPEND=">=sys-devel/autoconf-2.58
	>=sys-devel/automake-1.8
	>=app-arch/bzip2-1.0.2
	>=dev-libs/libxslt-1.0.31
	>=dev-libs/libxml2-2.5.8
	>=dev-libs/libpcre-3.9
	ssl? ( >=dev-libs/openssl-0.9.6k )
	alsa? ( media-libs/alsa-lib virtual/alsa )
	cups? ( >=net-print/cups-1.1.19 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	media-libs/tiff
	>=app-admin/fam-2.6.10
	virtual/ghostscript
	media-libs/libart_lgpl
	sys-devel/gettext
	~kde-base/arts-1.2.3
	>=x11-libs/qt-3.2.3"
RDEPEND="${DEPEND}
	app-text/sgml-common
	cups? ( net-print/cups )
	doc? ( app-doc/doxygen )
	dev-lang/python"

src_unpack() {
	unpack $PN-$PV.tar.bz2
	# This is an ugly hack: it makes base_src_unpack do nothing, but still lets us enjoy
	# the other things kde_src_unpack does.
	kde_src_unpack nounpack
	
	epatch ${DISTDIR}/post-3.2.3-kdelibs-kcookiejar.patch
	epatch ${DISTDIR}/post-3.2.3-kdelibs-kstandarddirs.patch
	epatch ${FILESDIR}/post-3.2.3-kdelibs-htmlframes.patch
	epatch ${DISTDIR}/post-3.2.3-kdelibs-htmlframes2.patch
	epatch ${FILESDIR}/post-3.2.3-kdelibs-khtml.diff
	epatch ${DISTDIR}/post-3.2.3-kdelibs-kioslave.patch
	epatch ${FILESDIR}/kde3-dcopidlng.patch
	cd ${S}/kio && patch -p0 < ${DISTDIR}/post-3.2.3-kdelibs-kio.diff
	cd ${S}/dcop && patch -p0 < ${DISTDIR}/post-3.2.3-kdelibs-dcopserver.patch
	cd ${S}
	make -f admin/Makefile.common || die
}

src_compile() {
	kde_src_compile myconf

	myconf="$myconf --with-distribution=Gentoo --enable-libfam --enable-dnotify"
	myconf="$myconf `use_with alsa` `use_enable cups`"

	use ipv6	|| myconf="$myconf --with-ipv6-lookup=no"
	use ssl		&& myconf="$myconf --with-ssl-dir=/usr"	|| myconf="$myconf --without-ssl"
	use alsa	&& myconf="$myconf --with-alsa" || myconf="$myconf --without-alsa"
	use cups	&& myconf="$myconf --enable-cups" || myconf="$myconf --disable-cups"

	use x86 && myconf="$myconf --enable-fast-malloc=full"

	kde_src_compile configure make

	use doc && make apidox
}

src_install() {
	kde_src_install
	dohtml *.html

	if use doc ; then
		einfo "Copying API documentation..."
		dodir ${KDEDIR}/share/doc/HTML/en/kdelibs-apidocs
		cp -r ${S}/apidocs/* ${D}/$KDEDIR/share/doc/HTML/en/kdelibs-apidocs
	else
		rm -r ${D}/$KDEDIR/share/doc/HTML/en/kdelibs-apidocs
	fi

	# needed to fix lib64 issues on amd64, see bug #45669
	use amd64 && ln -s ${KDEDIR}/lib ${D}/${KDEDIR}/lib64

}

pkg_postinst() {
	if use doc ; then
		rm $KDEDIR/share/doc/HTML/en/kdelibs-apidocs/common
		ln -sf $KDEDIR/share/doc/HTML/en/common \
			$KDEDIR/share/doc/HTML/en/kdelibs-apidocs/common
	fi
}
