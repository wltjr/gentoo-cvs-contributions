# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-ca/aspell-ca-0.60.20040130.ebuild,v 1.9 2007/11/03 22:00:12 uberlord Exp $

ASPELL_LANG="Catalan"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"

FILENAME="aspell6-ca-20040130-1"
SRC_URI="mirror://gnu/aspell/dict/ca/${FILENAME}.tar.bz2"
S=${WORKDIR}/${FILENAME}
