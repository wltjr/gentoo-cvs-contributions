# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django/django-0.91.ebuild,v 1.2 2006/03/29 15:30:35 sekretarz Exp $

inherit distutils

MY_P="${PN/d/D}-${PV}"
DESCRIPTION="high-level python web framework"
HOMEPAGE="http://www.djangoproject.com/"
SRC_URI="http://media.djangoproject.com/releases/${PV}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sqlite postgres mysql"

DEPEND=">=dev-lang/python-2.3
		dev-python/setuptools"

RDEPEND="sqlite? ( >=dev-python/pysqlite-2.0.3 )
		postgres? ( dev-python/psycopg )
		mysql? ( dev-python/mysql-python )"

S=${WORKDIR}/${MY_P}

src_install()
{
	distutils_python_version

	site_pkgs="/usr/$(get_libdir)/python${PYVER}/site-packages/"
	export PYTHONPATH="${PYTHONPATH}:${D}/${site_pkgs}"
	dodir ${site_pkgs}

	${python} setup.py install --root=${D} --no-compile \
		--single-version-externally-managed "$@" || die

	dodoc docs/* AUTHORS INSTALL LICENSE README PKG-INFO
}
