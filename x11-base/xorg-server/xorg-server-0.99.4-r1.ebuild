# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/xorg-server/xorg-server-0.99.4-r1.ebuild,v 1.1 2005/12/05 06:36:54 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
# Hack to make sure autoreconf gets run
#SNAPSHOT="yes"

inherit flag-o-matic x-modular multilib

OPENGL_DIR="xorg-x11"

MESA_PN="Mesa"
MESA_PV="6.4"
MESA_P="${MESA_PN}-${MESA_PV}"
MESA_SRC_P="${MESA_PN}Lib-${MESA_PV}"

#PATCHES="${FILESDIR}/fix-xkb-compile-path-2.patch"

SRC_URI="${SRC_URI}
	mirror://sourceforge/mesa3d/${MESA_SRC_P}.tar.bz2"
DESCRIPTION="X.Org X servers"
KEYWORDS="~amd64 ~arm ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE="dri ipv6 minimal xprint"
RDEPEND="x11-libs/libXfont
	x11-libs/xtrans
	x11-libs/libXau
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libXdmcp
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXi
	media-libs/freetype
	>=media-libs/mesa-6
	media-fonts/font-misc-misc
	media-fonts/font-cursor-misc
	x11-misc/xbitmaps
	x11-misc/xkbdata
	x11-apps/iceauth
	x11-apps/rgb
	x11-apps/xauth
	x11-apps/xinit
	app-admin/eselect-opengl
	x11-libs/libXaw
	x11-libs/libXpm
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	!minimal? ( x11-libs/libdmx
		x11-libs/libXtst
		x11-libs/libXres )
	x11-libs/libxkbui
	x11-libs/liblbxutil"
	# Xres is dmx-dependent, xkbui is xorgcfg-dependent
	# Xaw is dmx- and xorgcfg-dependent
	# Xpm is dmx- and xorgcfg-dependent, pulls in Xt
	# Xxf86misc and Xxf86vm are xorgcfg-dependent
	# liblbxutil is lbx- dependent
DEPEND="${RDEPEND}
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/fixesproto
	x11-proto/damageproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xf86dgaproto
	x11-proto/xf86miscproto
	x11-proto/xf86rushproto
	x11-proto/xf86vidmodeproto
	x11-proto/xf86bigfontproto
	x11-proto/compositeproto
	x11-proto/recordproto
	x11-proto/resourceproto
	x11-proto/videoproto
	x11-proto/scrnsaverproto
	x11-proto/evieext
	x11-proto/trapproto
	>=x11-proto/xineramaproto-1.1-r1
	x11-proto/fontsproto
	>=x11-proto/kbproto-1.0-r1
	x11-proto/inputproto
	x11-proto/bigreqsproto
	x11-proto/xcmiscproto
	>=x11-proto/glproto-1.4.1_pre20051013
	!minimal? ( x11-proto/dmxproto )
	dri? ( x11-proto/xf86driproto
		>=x11-libs/libdrm-2 )
	xprint? ( x11-proto/printproto
		x11-apps/mkfontdir
		x11-apps/mkfontscale )"

pkg_setup() {
	# localstatedir is used for the log location; we need to override the default
	# from ebuild.sh
	# sysconfdir is used for the xorg.conf location; same applies
	CONFIGURE_OPTIONS="
		$(use_enable ipv6)
		$(use_enable !minimal dmx)
		$(use_enable !minimal xvfb)
		$(use_enable !minimal xnest)
		$(use_enable dri)
		$(use_enable xprint)
		--enable-xcsecurity
		--with-mesa-source=${WORKDIR}/${MESA_P}
		--enable-xorg
		--enable-xtrap
		--enable-xevie
		--sysconfdir=/etc/X11
		--localstatedir=/var
		--disable-static
		--enable-install-setuid
		--with-default-font-path=/usr/share/fonts/misc,/usr/share/fonts/75dpi,/usr/share/fonts/100dpi,/usr/share/fonts/TTF,/usr/share/fonts/Type1"
}

src_install() {
	x-modular_src_install

	dynamic_libgl_install

	# As of 20051028, should be taken care of by upstream
	dosym Xorg /usr/bin/X
}

pkg_postinst() {
	switch_opengl_implem
}

pkg_postrm() {
	# Get rid of module dir to ensure opengl-update works properly
	if ! has_version x11-base/xorg-server; then
		if [ -e ${ROOT}/usr/$(get_libdir)/xorg/modules ]; then
			rm -rf ${ROOT}/usr/$(get_libdir)/xorg/modules
		fi
	fi
}

dynamic_libgl_install() {
	# next section is to setup the dynamic libGL stuff
	ebegin "Moving GL files for dynamic switching"
		dodir /usr/$(get_libdir)/opengl/${OPENGL_DIR}/extensions
		local x=""
		for x in ${D}/usr/$(get_libdir)/xorg/modules/libglx*; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f ${x} ${D}/usr/$(get_libdir)/opengl/${OPENGL_DIR}/extensions
			fi
		done
	eend 0
}

switch_opengl_implem() {
		# Switch to the xorg implementation.
		# Use new opengl-update that will not reset user selected
		# OpenGL interface ...
		echo
		eselect opengl set --use-old ${OPENGL_DIR}
}
