# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gtk-engines.eclass,v 1.12 2002/11/17 02:54:49 leonardop Exp $

# The gtk-engines eclass is inheritd by all gtk-engines-* ebuilds.

inherit base

ECLASS=gtk-engines
INHERITED="$INHERITED $ECLASS"

[ -n "$DEBUG" ] && einfo "Entering gtk-engines.eclass"

DESCRIPTION="Based on the ${ECLASS} eclass"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"
KEYWORDS="x86 ppc alpha"

newdepend /c virtual/x11

case "${SLOT}" in
	"1" )
		newdepend '=x11-libs/gtk+-1.2*' ;;
	"2" )
		newdepend '>=x11-libs/gtk+-2' ;;
	* )
		newdepend x11-libs/gtk+ ;;
esac

[ -n "$DEBUG" ] && einfo "SLOT is ${SLOT}"

MY_PN="${PN}"
INSTALL_FONTS=0
ENGINE=${PN/gtk-engines-/}

[ -n "$DEBUG" ] && einfo "ENGINE is ${ENGINE}"

case "${ENGINE}" in
	"cleanice" )
		[ "$SLOT" -eq "2" ] && MY_PN="gtk-engines-cleanice2" ;;
		
	"crux" )
		MY_PN="crux"
		newdepend '>=gnome-base/libgnomeui-2.0.1' \
			'>=gnome-base/libglade-2.0.0'
		DEPEND="${DEPEND} sys-devel/libtool"
		;;
		
	"eazel" )
		MY_PN="eazel-engine"
		newdepend media-libs/gdk-pixbuf
		# This one needs the capplet stuff from gnomecc-1.4.  Some
		# tests also need libglade, but it is a heavy dep, so dont
		# know if we should rather disabled the tests...
		[ "${SLOT}" -eq 1 ] && newdepend "=gnome-base/control-center-1.4*"
		;;

	"flat" )
		if [ "$SLOT" -eq "2" ]
		then
			MY_PN="gtk-flat-theme-2.0"
		fi
		;;
	
	"geramik" )
		MY_PN="3952-Geramik" ;;
		
	"gtkstep" )
		LICENSE="LGPL-2" ;;
		
	"lighthouseblue" )
		MY_PN="lighthouseblue" ;;
		
	"metal" | "notif" | "pixbuf" | "pixmap" | "raleigh" | "redmond95" )
		MY_PN="gtk-engines"
		if [ "$SLOT" -eq "2" ]
		then
			newdepend media-libs/gdk-pixbuf
			DEPEND="${DEPEND} >=dev-util/pkgconfig-0.12.0"

			# Do _NOT_ strip symbols in the build! Need both lines for Portage
			# 1.8.9+
			DEBUG="yes"
			RESTRICT="nostrip"
			# force debug information
			CFLAGS="${CFLAGS} -g"
			CXXFLAGS="${CXXFLAGS} -g"
			
		else
			newdepend '>=media-libs/imlib-1.8'
		fi
		;;
		
	"mist" )
		MY_PN="GTK-mist-engine" ;;
	
	"thinice" )
		[ "$SLOT" -eq "2" ] && MY_PN="gtk-thinice-engine" ;;
		
	"xenophilia" )
		MY_PN="xenophilia"
		INSTALL_FONTS=1
		LICENSE="LGPL-2"
		;;
		
	"xfce" )
		MY_PN="gtk-xfce-engine" ;;
esac

MY_P="${MY_PN}-${PV}"

[ -n "$DEBUG" ] && einfo "MY_P is ${MY_P}"

if [ "X${ENGINE}" = "Xthinice" ] && [ "$SLOT" -eq "2" ]
then
	SRC_URI="http://thinice.sourceforge.net/${MY_P}.tar.gz"
	
elif [ "X${ENGINE}" = "Xmist" ]
then
	SRC_URI="http://ftp.gnome.org/pub/GNOME/teams/art.gnome.org/themes/gtk2/${MY_P}.tar.gz"
	
elif [ "X${ENGINE}" = "Xflat" ] && [ "$SLOT" -eq "2" ]
then
	SRC_URI="http://download.freshmeat.net/themes/gtk2flat/gtk2flat-default.tar.gz"
	
elif [ "X${ENGINE}" = "Xgeramik" ]
then
	SRC_URI="http://www.kde-look.org/content/files/${MY_P}.tar.gz"
	
elif [ "X${ENGINE}" = "Xxfce" ]
then
	SRC_URI="mirror://sourceforge/xfce/${MY_P}.tar.gz"
	
elif [ "X${ENGINE}" = "Xlighthouseblue" ]
then
	SRC_URI="mirror://sourceforge/lighthouseblue/${MY_P}.tar.gz"
	
elif [ "X${ENGINE}" = "Xcrux" ]
then
	SRC_URI="mirror://gnome/2.0.1/sources/${MY_PN}/${MY_P}.tar.bz2"
	
elif [ "X${MY_PN}" = "Xgtk-engines" ] && [ "$SLOT" -eq "2" ]
then
	SRC_URI="mirror://gnome/2.0.1/sources/${MY_PN}/${MY_P}.tar.bz2"

else
	SRC_PATH=`echo ${MY_PN} | awk '{print substr($0,1,1);}'`
	SRC_PATH="${SRC_PATH}/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"
	SRC_URI="http://ftp.debian.org/debian/pool/main/$SRC_PATH"
fi

[ -n "$DEBUG" ] && einfo "SRC_URI is ${SRC_URI}"

gtk-engines_src_unpack() {
	unpack ${A}
	
	MY_DIR=`ls -t ${WORKDIR} | head -n 1`

	mv $MY_DIR $S
}

gtk-engines_src_compile() {
	econf || die "Configuration failed"
	
	if [ "X${MY_PN}" = "Xgtk-engines" ]
	then
		cd ${ENGINE}
	fi
	
	emake || die "Compilation failed"
}

gtk-engines_src_install() {
	if [ "X${MY_PN}" = "Xgtk-engines" ]
	then
		cd ${ENGINE}
	fi

	if [ "X${MY_PN}" = "Xxenophilia" ]
	then
		dodir /usr/X11R6/lib/X11/fonts/misc
		
		mv fonts/Makefile fonts/Makefile.orig
		sed -e 's:/usr:${D}/usr:' \
			-e 's:local:misc:' \
			-e '7,8d' \
			fonts/Makefile.orig > fonts/Makefile || die
		rm fonts/Makefile.orig
	fi

	einstall \
		THEME_DIR=${D}/usr/share/themes \
		ENGINE_DIR=${D}/usr/lib/gtk/themes/engines || \
		die "Installation failed"

	if [ "X${MY_PN}" = "XGTK-mist-engine" ]
	then
		if [ "$SLOT" -eq "2" ]
		then
			rm -rf ${D}/usr/lib/gtk ${D}/usr/share/themes/Mist/gtk
		else
			rm -rf ${D}/usr/lib/gtk-2.0 ${D}/usr/share/themes/Mist/gtk-2.0
		fi

		rm -rf ${D}/usr/share/themes/Mist/metacity-1
	fi
	
	for doc in AUTHORS BUGS ChangeLog CONFIGURATION COPYING CUSTOMIZATION \
		NEWS README THANKS TODO
	do
		[ -s $doc ] && dodoc $doc
	done
}

gtk-engines_pkg_postinst() {
	if [ "$INSTALL_FONTS" -ne 0 ]
	then
		echo ">>> Updating X fonts..."
		mkfontdir /usr/X11R6/lib/X11/fonts/misc
		xset fp rehash || fonts_notice
	fi
}

gtk-engines_pkg_postrm() {
	if [ "$INSTALL_FONTS" -ne 0 ]
	then
		echo ">>> Updating X fonts..."
		mkfontdir /usr/X11R6/lib/X11/fonts/misc
		xset fp rehash || fonts_notice
	fi
}

fonts_notice() {
	einfo ""
	einfo "*************************************************************"
	einfo ""
	einfo "We can't reset the font path at the moment. You might want"
	einfo "to run the following command manually:"
	einfo ""
	einfo "  xset fp rehash"
	einfo ""
	einfo "*************************************************************"
	einfo ""
}
										
EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_postrm
