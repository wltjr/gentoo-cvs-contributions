# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/verve/verve-0.3.5.ebuild,v 1.19 2007/07/01 09:35:27 welp Exp $

inherit xfce44

xfce44

DESCRIPTION="Command line panel plugin"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="dbus debug"

RDEPEND=">=xfce-extra/exo-0.3.2
	dev-libs/libpcre
	dbus? ( dev-libs/dbus-glib )"
DEPEND="${RDEPEND}
	dev-util/intltool"

xfce44_goodies_panel_plugin
