# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gnome2-canvas/gnome2-canvas-1.002.ebuild,v 1.13 2008/04/20 15:41:56 drac Exp $

inherit perl-module

MY_P=Gnome2-Canvas-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Perl interface to the Gnome Canvas"
SRC_URI="mirror://cpan/authors/id/T/TS/TSCH/${MY_P}.tar.gz"
HOMEPAGE="http://gtk2-perl.sf.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ia64 ~ppc sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libgnomecanvas-2
	>=dev-perl/glib-perl-1.040
	>=dev-perl/gtk2-perl-1.040
	>=dev-perl/extutils-pkgconfig-1.03
	>=dev-perl/extutils-depends-0.202
	dev-lang/perl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
