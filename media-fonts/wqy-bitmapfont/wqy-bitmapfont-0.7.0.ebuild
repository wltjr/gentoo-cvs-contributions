# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/wqy-bitmapfont/wqy-bitmapfont-0.7.0.ebuild,v 1.3 2006/11/26 23:10:56 flameeyes Exp $

inherit font

DESCRIPTION="WenQuanYi Bitmap Song CJK font"
HOMEPAGE="http://wqy.sourceforge.net/en/"
SRC_URI="mirror://sourceforge/wqy/${PN}-pcf-${PV}-4.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm ~hppa ia64 ~ppc s390 sh ~x86 ~x86-fbsd"
IUSE=""
DEPEND=""
S="${WORKDIR}/${PN}"
FONT_S="${S}"

FONT_SUFFIX="pcf"
DOCS="INSTALL* LATEST-IS* STAT README LOGO.PNG CREDIT ChangeLog"

# Only installs fonts
RESTRICT="strip binchecks"
