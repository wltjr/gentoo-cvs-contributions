# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/celestia/celestia-1.5.0.ebuild,v 1.2 2008/04/15 15:52:53 bicatali Exp $

inherit eutils flag-o-matic gnome2 kde-functions autotools

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="http://www.shatters.net/celestia/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="arts cairo gnome gtk kde lua nls pch theora threads"

RDEPEND="virtual/glu
	media-libs/jpeg
	media-libs/libpng
	gtk? ( !gnome? ( !kde? (
		>=x11-libs/gtk+-2.6
		>=x11-libs/gtkglext-1.0
	) ) )
	gnome? ( !kde? (
		>=x11-libs/gtk+-2.6
		>=x11-libs/gtkglext-1.0
		>=gnome-base/libgnomeui-2.0
	) )
	kde?  ( !gnome? ( >=kde-base/kdelibs-3.0.5 ) )
	!gtk? ( !gnome? ( !kde? ( virtual/glut ) ) )
	arts? ( kde-base/arts )
	lua? ( >=dev-lang/lua-5.0 )
	cairo? ( x11-libs/cairo )
	theora? ( media-libs/libtheora )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	# Check for one for the following use flags to be set.

	if ! use gnome && use kde; then
		einfo "USE=\"kde\" detected."
		CELESTIA_GUI="kde"
	elif ! use kde && use gnome; then
		einfo "USE=\"gnome\" detected."
		USE_DESTDIR="1"
		CELESTIA_GUI="gnome"
	elif ! use kde && ! use gnome && use gtk; then
		einfo "USE=\"gtk\" detected."
		CELESTIA_GUI="gtk"
	elif use kde && use gnome; then
		einfo "Both gnome and kde support requested. Defaulting to kde"
		CELESTIA_GUI="kde"
	else
		ewarn "If you want to use the full gui, set USE=\"{kde/gnome/gtk}\""
		ewarn "Defaulting to glut support (no GUI)."
		CELESTIA_GUI="glut"
	fi
}

src_unpack() {

	unpack ${A}
	cd "${S}"
	# make better desktop files
	epatch "${FILESDIR}"/${P}-desktop.patch

	# add a ~/.celestia for extra directories
	epatch "${FILESDIR}"/${PN}-1.4.1-cfg.patch

	# fix for as-needed (bug #130091)
	epatch "${FILESDIR}"/${PN}-1.4.1-as-needed.patch

	# fix for as-needed (bug #217758)
	epatch "${FILESDIR}"/${P}-gcc43.patch

	# remove flags to let the user decide
	for cf in -O2 -ffast-math \
		-fexpensive-optimizations \
		-fomit-frame-pointer; do
		sed -i \
			-e "s/${cf}//g" \
			configure.in || die "sed failed"
	done

	# remove an unused gconf macro killing autoconf when no gnome
	# (not needed without eautoreconf)
	if ! use gnome; then
		sed -i \
			-e '/AM_GCONF_SOURCE_2/d' \
			configure.in || die "sed failed"
	fi

	eautoreconf
}

src_compile() {

	if [[ ${CELESTIA_GUI} == kde ]]; then
		set-kdedir 3
		set-qtdir 3
		export kde_widgetdir="${KDEDIR}/lib/kde3/plugins/designer"
	fi

	filter-flags "-funroll-loops -frerun-loop-opt"

	econf \
		--with-${CELESTIA_GUI} \
		$(use_with arts) \
		$(use_with lua) \
		$(use_enable cairo) \
		$(use_enable threads threading) \
		$(use_enable nls) \
		$(use_enable pch) \
		$(use_enable theora) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	if [[ ${CELESTIA_GUI} == gnome ]]; then
		gnome2_src_install
	else
		emake DESTDIR="${D}" install || die "emake install failed"
		for size in 16 22 32 48 ; do
			insinto /usr/share/icons/hicolor/${size}x${size}/apps
			newins "${S}"/src/celestia/kde/data/hi${size}-app-${PN}.png ${PN}.png
		done
	fi
	[[ ${CELESTIA_GUI} == glut ]] && domenu celestia.desktop
	dodoc AUTHORS README TODO TRANSLATORS *.txt || die
}
