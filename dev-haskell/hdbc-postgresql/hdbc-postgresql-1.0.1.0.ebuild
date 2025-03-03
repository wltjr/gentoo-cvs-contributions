# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hdbc-postgresql/hdbc-postgresql-1.0.1.0.ebuild,v 1.3 2008/05/19 19:18:59 dev-zero Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal versionator

DESCRIPTION="PostgreSQL database driver for HDBC"
HOMEPAGE="http://quux.org/devel/hdbc/"
SRC_URI="http://quux.org/devel/hdbc/${PN}_${PV}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~sparc"
IUSE=""

hdbc_PV=$(get_version_component_range 1-3)

DEPEND=">=dev-lang/ghc-6.4.1
	~dev-haskell/hdbc-${hdbc_PV}
	>=virtual/postgresql-base-8"

S="${WORKDIR}/${PN}"
