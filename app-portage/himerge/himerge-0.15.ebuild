# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/himerge/himerge-0.15.ebuild,v 1.3 2008/01/20 18:57:26 angelos Exp $

inherit base haskell-cabal

DESCRIPTION="Haskell Graphical User Interface for the Gentoo's Portage System."
HOMEPAGE="http://www.haskell.org/himerge/"
SRC_URI="http://www.haskell.org/himerge/release/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6
	>=dev-haskell/gtk2hs-0.9.12
	>=app-portage/eix-0.9.3
	>=app-portage/gentoolkit-0.2.3
	>=app-portage/portage-utils-0.1.28"
RDEPEND=""

pkg_setup() {
	if ! built_with_use -o dev-haskell/gtk2hs firefox seamonkey xulrunner; then
	   	echo
		eerror "gtk2hs was not merged with the firefox or seamonkey USE flag."
		eerror "Himerge requires gtk2hs be compiled with any of these flags."
		die "gtk2hs missing web browser support."
	fi
}

src_install() {
	cabal-copy
	cabal-pkg
	einfo "Installing data files."
	mkdir -p "${D}"/usr/share/himerge/icons
	mkdir -p "${D}"/usr/share/doc/"${P}"
	cp "${S}"/data/himerge/doc/himerge.css "${D}"/usr/share/doc/"${P}"/
	cp "${S}"/data/himerge/doc/himerge_doc.html "${D}"/usr/share/doc/"${P}"/
	cp "${S}"/data/himerge/icons/* "${D}"/usr/share/himerge/icons/
}
