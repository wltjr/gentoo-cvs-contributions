# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/wine/wine-0.9.ebuild,v 1.15 2008/03/27 18:22:16 vapier Exp $

inherit eutils flag-o-matic multilib

DESCRIPTION="free implementation of Windows(tm) on Unix"
HOMEPAGE="http://www.winehq.org/"
SRC_URI="mirror://sourceforge/${PN}/wine-${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="alsa arts cups debug esd gif glut jack jpeg lcms ldap nas ncurses opengl oss scanner truetype xml X"
RESTRICT="test" #72375

RDEPEND=">=media-libs/freetype-2.0.0
	media-fonts/corefonts
	ncurses? ( >=sys-libs/ncurses-5.2 )
	jack? ( media-sound/jack-audio-connection-kit )
	X? (
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm
		x11-apps/xmessage
	)
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
	esd? ( media-sound/esound )
	nas? ( media-libs/nas )
	cups? ( net-print/cups )
	opengl? ( virtual/opengl )
	gif? ( media-libs/giflib )
	jpeg? ( media-libs/jpeg )
	ldap? ( net-nds/openldap )
	glut? ( virtual/glut )
	lcms? ( media-libs/lcms )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	truetype? ( media-libs/freetype media-gfx/fontforge )
	scanner? ( media-gfx/sane-backends )
	amd64? (
		>=app-emulation/emul-linux-x86-xlibs-2.1
		>=app-emulation/emul-linux-x86-soundlibs-2.1
		>=sys-kernel/linux-headers-2.6
	)"
DEPEND="${RDEPEND}
	X? (
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86dgaproto
		x11-proto/xf86vidmodeproto
	)
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	if use amd64 ; then
		if ! has_m32 ; then
			eerror "Your compiler seems to be unable to compile 32bit code."
			eerror "Make sure you compile gcc with:"
			echo
			eerror "    USE=multilib FEATURES=-sandbox"
			die "Cannot produce 32bit code"
		fi
		if has_multilib_profile ; then
			export ABI=x86
		else
			append-flags -m32
			append-ldflags -m32
		fi
	fi
}

src_unpack() {
	unpack wine-${PV}.tar.bz2
	cd "${S}"

	epatch "${FILESDIR}"/wine-wmf.patch
	epatch "${FILESDIR}"/wine-20050524-alsa-headers.patch
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in
	epatch "${FILESDIR}"/wine-no-ssp.patch #66002
	epatch "${FILESDIR}"/wine-20050830-gcc-32bit.patch
	sed -i '/^MimeType/d' tools/wine.desktop || die #117785
}

config_cache() {
	local h ans="no"
	use $1 && ans="yes"
	shift
	for h in "$@" ; do
		[[ ${h} == *.h ]] \
			&& h=header_${h} \
			|| h=lib_${h}
		export ac_cv_${h//[:\/.]/_}=${ans}
	done
}

src_compile() {
	export LDCONFIG=/bin/true
	use arts    || export ARTSCCONFIG=""
	use esd     || export ESDCONFIG=""
	use scanner || export sane_devel="no"
	config_cache jack jack/jack.h
	config_cache cups cups/cups.h
	config_cache alsa alsa/asoundlib.h sys/asoundlib.h asound:snd_pcm_open
	config_cache nas audio/audiolib.h audio/soundlib.h
	config_cache xml libxml/parser.h libxslt/pattern.h libxslt/transform.h
	config_cache ldap ldap.h lber.h
	config_cache gif gif_lib.h
	config_cache glut glut:glutMainLoop
	config_cache jpeg jpeglib.h
	config_cache oss sys/soundcard.h machine/soundcard.h soundcard.h
	config_cache lcms lcms.h
	use x86 && config_cache truetype freetype:FT_Init_FreeType

	strip-flags

	#	$(use_enable amd64 win64)
	econf \
		CC=$(tc-getCC) \
		--sysconfdir=/etc/wine \
		$(use_with ncurses curses) \
		$(use_with opengl) \
		$(use_with X x) \
		$(use_enable debug trace) \
		$(use_enable debug) \
		|| die "configure failed"

	emake -j1 depend || die "depend"
	emake all || die "all"
}

src_install() {
	make \
		prefix="${D}"/usr \
		bindir="${D}"/usr/bin \
		datadir="${D}"/usr/share \
		includedir="${D}"/usr/include/wine \
		sysconfdir="${D}"/etc/wine \
		mandir="${D}"/usr/share/man \
		libdir="${D}"/usr/$(get_libdir) \
		dlldir="${D}"/usr/$(get_libdir)/wine \
		install || die

	dodoc ANNOUNCE AUTHORS BUGS ChangeLog DEVELOPERS-HINTS README
}

pkg_postinst() {
	elog "~/.wine/config is now deprecated.  For configuration either use"
	elog "winecfg or regedit HKCU\\Software\\Wine"
}
