# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-Test-Simple/perl-Test-Simple-0.62.ebuild,v 1.5 2007/07/11 05:04:22 mr_bones_ Exp $

DESCRIPTION="Virtual for Test-Simple"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

IUSE=""
DEPEND=""
RDEPEND="|| ( ~dev-lang/perl-5.8.8 ~perl-core/Test-Simple-${PV} )"
