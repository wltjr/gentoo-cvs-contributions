# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/extutils-pkgconfig/extutils-pkgconfig-1.07.ebuild,v 1.14 2008/04/08 09:21:37 tove Exp $

inherit perl-module

MY_P=ExtUtils-PkgConfig-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Simplistic perl interface to pkg-config"
HOMEPAGE="http://search.cpan.org/~rmcfarla/"
SRC_URI="mirror://cpan/authors/id/R/RM/RMCFARLA/Gtk2-Perl/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-lang/perl
	dev-util/pkgconfig"
RDEPEND="${DEPEND}"
