# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-sdl/emul-linux-x86-sdl-20080316.ebuild,v 1.1 2008/03/17 07:20:13 welp Exp $

inherit emul-linux-x86

LICENSE="LGPL-2 LGPL-2.1"
KEYWORDS="-* ~amd64"

DEPEND=""
RDEPEND=">=app-emulation/emul-linux-x86-xlibs-20071114
	>=app-emulation/emul-linux-x86-baselibs-20071114
	>=app-emulation/emul-linux-x86-soundlibs-20071114"
