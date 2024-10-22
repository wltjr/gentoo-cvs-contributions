# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-sr/aspell-sr-0.60.ebuild,v 1.16 2007/11/03 22:21:31 uberlord Exp $

ASPELL_LANG="Serbian"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"

FILENAME="aspell6-sr-0.02"
SRC_URI="http://srpski.org/aspell/${FILENAME}.tar.bz2"
S=${WORKDIR}/${FILENAME}
