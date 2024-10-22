# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-adobe-utopia-75dpi/font-adobe-utopia-75dpi-1.0.1.ebuild,v 1.16 2008/02/24 11:59:10 armin76 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Adobe Utopia bitmap fonts"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf
	media-fonts/font-util"

CONFIGURE_OPTIONS="--with-mapfiles=${XDIR}/share/fonts/util"
