# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/glut/glut-2.1.1.ebuild,v 1.6 2007/12/16 20:34:05 drac Exp $

CABAL_FEATURES="haddock lib profile"
inherit haskell-cabal

MY_PN=GLUT
GHC_PV=6.6.1

DESCRIPTION="GLUT bindings for haskell"
HOMEPAGE="http://www.haskell.org/HOpenGL/"
SRC_URI="http://www.haskell.org/ghc/dist/${GHC_PV}/ghc-${GHC_PV}-src-extralibs.tar.bz2"
LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 ~sparc x86"

# TODO: Install examples when the "examples" USE flag is set
IUSE=""

DEPEND=">=dev-lang/ghc-6.6
	>=dev-haskell/opengl-2.2.1
	virtual/glu
	virtual/glut"

S="${WORKDIR}/ghc-${GHC_PV}/libraries/${MY_PN}"

src_unpack() {
	unpack "${A}"
	cabal-mksetup
}
