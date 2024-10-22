# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXprintUtil/libXprintUtil-1.0.1.ebuild,v 1.15 2006/09/10 09:11:11 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org XprintUtil library"

KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

RDEPEND="x11-libs/libX11
	x11-libs/libXp"
DEPEND="${RDEPEND}
	x11-libs/libXt
	x11-proto/printproto"
