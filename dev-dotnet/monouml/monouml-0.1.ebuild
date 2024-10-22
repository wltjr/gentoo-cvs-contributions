# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/monouml/monouml-0.1.ebuild,v 1.6 2008/05/30 22:45:28 jurek Exp $

inherit mono eutils

MY_PV=20050529
MY_P=${P}-${MY_PV}
EC_P=expertcoder-bin-20050503

DESCRIPTION="CASE tool based on Mono Framework"
HOMEPAGE="http://www.monouml.org"
SRC_URI="http://forge.novell.com/modules/xfcontent/private.php/${PN}/MonoUML/${MY_P}.tar.gz
		mirror://sourceforge/expertcoder/${EC_P}.zip"

LICENSE="GPL-2"
IUSE=""
DEPEND=">=dev-lang/mono-1.1.4
	    >=dev-dotnet/gtk-sharp-1.9.2
		>=dev-dotnet/gnome-sharp-1.9.2
		>=dev-dotnet/glade-sharp-1.9.2
		app-arch/unzip
		dev-util/pkgconfig"

KEYWORDS="amd64 x86"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd "${S}"

	cp "${WORKDIR}"/${EC_P}/*.dll "${WORKDIR}"/${P}/bin/ || die
}

src_install() {
	make DESTDIR="${D}" install || die

	# Workaround for messed up paths
	dodir /usr/$(get_libdir)
	mv "${D}"/usr/monouml "${D}"/usr/$(get_libdir)/
	sed -i -e "s#/usr/${PN}#/usr/$(get_libdir)/${PN}#g" "${D}"/usr/bin/monouml

	dodoc ChangeLog README AUTHORS
}
