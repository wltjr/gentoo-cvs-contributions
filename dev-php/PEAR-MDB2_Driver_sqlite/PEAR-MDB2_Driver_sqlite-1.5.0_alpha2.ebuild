# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-MDB2_Driver_sqlite/PEAR-MDB2_Driver_sqlite-1.5.0_alpha2.ebuild,v 1.7 2008/03/29 00:01:04 maekke Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Database Abstraction Layer, sqlite driver"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=">=dev-php/PEAR-MDB2-2.5.0_alpha2"
RDEPEND="${DEPEND}"

pkg_setup() {
	require_sqlite
}
