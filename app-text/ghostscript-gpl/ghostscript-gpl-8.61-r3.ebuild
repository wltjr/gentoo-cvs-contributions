# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ghostscript-gpl/ghostscript-gpl-8.61-r3.ebuild,v 1.2 2008/03/01 20:21:21 armin76 Exp $

inherit autotools elisp-common eutils versionator flag-o-matic

DESCRIPTION="GPL Ghostscript - the most current Ghostscript, AFPL, relicensed"
HOMEPAGE="http://ghostscript.com/"

MY_P=${P/-gpl}
GSDJVU_PV=1.3
PVM=$(get_version_component_range 1-2)
SRC_URI="cjk? ( ftp://ftp.gyve.org/pub/gs-cjk/adobe-cmaps-200406.tar.gz
		ftp://ftp.gyve.org/pub/gs-cjk/acro5-cmaps-2001.tar.gz )
	!bindist? ( djvu? ( mirror://sourceforge/djvu/gsdjvu-${GSDJVU_PV}.tar.gz ) )
	mirror://sourceforge/ghostscript/${MY_P}.tar.bz2
	mirror://gentoo/${P}-patchset-4.tar.bz2"

LICENSE="GPL-2 CPL-1.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="bindist cjk cups djvu gtk X"

COMMON_DEPEND="media-libs/fontconfig
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2.5
	>=media-libs/tiff-3.7
	>=sys-libs/zlib-1.1.4
	!bindist? ( djvu? ( app-text/djvu ) )
	cups? ( >=net-print/cups-1.1.20 )
	gtk? ( >=x11-libs/gtk+-2.0 )
	X? ( x11-libs/libXt x11-libs/libXext )
	!app-text/ghostscript-esp
	!app-text/ghostscript-gnu"

DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	cjk? ( media-fonts/arphicfonts
		media-fonts/kochi-substitute
		media-fonts/baekmuk-fonts )
	media-fonts/gnu-gs-fonts-std"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A/adobe-cmaps-200406.tar.gz acro5-cmaps-2001.tar.gz}
	if use cjk ; then
		cat "${WORKDIR}/patches/ghostscript-esp-8.15.2-cidfmap.cjk" >> "${S}/lib/cidfmap"
		cat "${WORKDIR}/patches/ghostscript-esp-8.15.2-FAPIcidfmap.cjk" >> "${S}/lib/FAPIcidfmap"
		cd "${S}/Resource"
		unpack adobe-cmaps-200406.tar.gz
		unpack acro5-cmaps-2001.tar.gz
		cd "${WORKDIR}"
	fi

	cd "${S}"

	# remove internal copies of jpeg and libpng
	rm -rf "${S}/jpeg"
	rm -rf "${S}/libpng"

	# Fedora patches
	# upstream bug http://bugs.ghostscript.com/show_bug.cgi?id=689393
	epatch "${WORKDIR}/patches/${PN}-8.60-fPIC.patch"
	epatch "${WORKDIR}/patches/${PN}-8.61-multilib.patch"
	epatch "${WORKDIR}/patches/${PN}-8.60-noopt.patch"
	epatch "${WORKDIR}/patches/${PN}-8.60-scripts.patch"

	# fixed in trunk, upstream bug http://bugs.ghostscript.com/show_bug.cgi?id=689577
	epatch "${WORKDIR}/patches/${PN}-8.61-gsbug689577.patch"

	# hp ijs patch shipped with net-print/hplip
	epatch "${WORKDIR}/patches/${PN}-8.61-gdevijs-krgb-1.5.patch"

	# additional Gentoo patch, compile fix
	epatch "${WORKDIR}/patches/${PN}-8.61-rinkj.patch"

	# Security fix for bug #208999
	epatch "${WORKDIR}"/patches/ghostscript-8.60-CVE-2008-0411.diff

	if use bindist && use djvu ; then
		ewarn "You have bindist in your USE, djvu support will NOT be compiled!"
		ewarn "See http://djvu.sourceforge.net/gsdjvu/COPYING for details on licensing issues."
	fi

	if ! use bindist && use djvu ; then
		unpack gsdjvu-${GSDJVU_PV}.tar.gz
		cp gsdjvu-${GSDJVU_PV}/gsdjvu "${S}"
		cp gsdjvu-${GSDJVU_PV}/gdevdjvu.c "${S}/src"
		epatch "${WORKDIR}/patches/${PN}-8.61-gsdjvu-1.3.patch"
		cp gsdjvu-${GSDJVU_PV}/ps2utf8.ps "${S}/lib"
		cp "${S}/src/contrib.mak" "${S}/src/contrib.mak.gsdjvu"
		grep -q djvusep "${S}/src/contrib.mak" || \
			cat gsdjvu-${GSDJVU_PV}/gsdjvu.mak >> "${S}/src/contrib.mak"

		# install ps2utf8.ps, bug #197818
		sed -i -e '/$(EXTRA_INIT_FILES)/ a\ps2utf8.ps \\' "${S}/src/unixinst.mak" \
		|| die "sed failed"
	fi

	if ! use gtk ; then
		sed -i "s:\$(GSSOX)::" src/*.mak || die "gsx sed failed"
		sed -i "s:.*\$(GSSOX_XENAME)$::" src/*.mak || die "gsxso sed failed"
	fi

	# search path fix
	sed -i -e "s:\$\(gsdatadir\)/lib:/usr/share/ghostscript/${PVM}/$(get_libdir):" \
		-e 's:$(gsdir)/fonts:/usr/share/fonts/default/ghostscript/:' \
		-e "s:exdir=.*:exdir=/usr/share/doc/${PF}/examples:" \
		-e "s:docdir=.*:docdir=/usr/share/doc/${PF}/html:" \
		-e "s:GS_DOCDIR=.*:GS_DOCDIR=/usr/share/doc/${PF}/html:" \
		src/Makefile.in src/*.mak || die "sed failed"

	cd "${S}"
	eautoreconf

	cd "${S}/ijs"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable cups) \
		$(use_enable gtk) \
		$(use_with X x) \
		--enable-dynamic \
		--enable-fontconfig \
		--with-drivers=ALL,rinkj \
		--with-ijs \
		--with-jasper \
		--with-jbig2dec \
	|| die "econf failed"

	if ! use bindist && use djvu ; then
		sed -i -e 's!$(DD)bbox.dev!& $(DD)djvumask.dev $(DD)djvusep.dev!g' Makefile
	fi

	emake -j1 so all || die "emake failed"

	cd "${S}/ijs"
	econf || die "ijs econf failed"
	emake || die "ijs emake failed"
}

src_install() {
	emake DESTDIR="${D}" install-so install || die "emake install failed"

	if ! use bindist && use djvu ; then
		dobin gsdjvu || die "dobin gsdjvu install failed"
	fi

	rm -rf "${D}/usr/share/doc/${PF}/html/"{README,PUBLIC}
	dodoc doc/README || die "dodoc install failed"

	cd "${S}/ijs"
	emake DESTDIR="${D}" install || die "emake ijs install failed"
}
