# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gnome2-gconf/gnome2-gconf-1.043.ebuild,v 1.8 2008/04/20 15:38:01 drac Exp $

inherit perl-module

MY_P=Gnome2-GConf-${PV}

DESCRIPTION="Perl wrappers for the GConf configuration engine."
SRC_URI="mirror://cpan/authors/id/E/EB/EBASSI/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~rmcfarla/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~ppc sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/gconf-2
	>=dev-perl/glib-perl-1.120
	>=dev-perl/gtk2-perl-1.120
	>=dev-perl/extutils-pkgconfig-1.03
	>=dev-perl/extutils-depends-0.202
	dev-lang/perl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
