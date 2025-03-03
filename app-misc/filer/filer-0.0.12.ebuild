# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/filer/filer-0.0.12.ebuild,v 1.10 2008/03/13 21:05:32 jer Exp $

inherit eutils

DESCRIPTION="Small file-manager written in perl"
HOMEPAGE="http://wiki.perldude.de/doku.php?id=filer"
SRC_URI="http://perldude.de/projects/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc sparc x86"
IUSE=""

RDEPEND="dev-lang/perl
	>=dev-perl/gtk2-perl-1.080
	dev-perl/gtk2-gladexml
	dev-perl/File-MimeInfo
	dev-perl/File-DirWalk
	virtual/perl-File-Temp
	dev-perl/TimeDate
	dev-perl/glib-perl
	dev-perl/extutils-depends
	dev-perl/extutils-pkgconfig
	>=x11-libs/gtk+-2.6
	x11-misc/shared-mime-info
	dev-perl/Stat-lsMode"
DEPEND="sys-apps/findutils"

src_unpack() {
	unpack ${A}
	find "${S}" -type d -name .svn | xargs rm -rf
	cd "${S}"
	epatch "${FILESDIR}"/filer-0.0.12-trash.patch
}

src_compile() {
	true
}

src_install() {
	dodir /usr/bin
	dodir /usr/lib
	make install PREFIX="${D}"/usr/
	dodoc AUTHORS README ChangeLog  || die "dodoc failed"
}
