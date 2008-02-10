# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-MDB2/PEAR-MDB2-2.5.0_alpha2.ebuild,v 1.5 2008/02/10 14:17:34 nixnut Exp $

inherit php-pear-r1

DESCRIPTION="Database Abstraction Layer"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE="mssql mysql mysqli oci8 oci8-instant-client postgres sqlite"

PDEPEND="mssql? ( >=dev-php/PEAR-MDB2_Driver_mssql-1.3.0_alpha2 )
		mysql? ( >=dev-php/PEAR-MDB2_Driver_mysql-1.5.0_alpha2 )
		mysqli? ( >=dev-php/PEAR-MDB2_Driver_mysqli-1.5.0_alpha2 )
		oci8? ( >=dev-php/PEAR-MDB2_Driver_oci8-1.5.0_alpha2 )
		oci8-instant-client? ( >=dev-php/PEAR-MDB2_Driver_oci8-1.5.0_alpha2 )
		postgres? ( >=dev-php/PEAR-MDB2_Driver_pgsql-1.5.0_alpha2 )
		sqlite? ( >=dev-php/PEAR-MDB2_Driver_sqlite-1.5.0_alpha2 )"
