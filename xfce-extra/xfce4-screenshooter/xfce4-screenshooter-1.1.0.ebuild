# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-screenshooter/xfce4-screenshooter-1.1.0.ebuild,v 1.1 2008/06/17 12:20:03 angelos Exp $

inherit eutils xfce44

xfce44
xfce44_gzipped

DESCRIPTION="Xfce4 panel screenshooter plugin"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

DOCS="AUTHORS ChangeLog NEWS README"

xfce44_goodies_panel_plugin
