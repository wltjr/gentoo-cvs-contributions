# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_cband/mod_cband-0.9.7.5.ebuild,v 1.5 2007/06/12 00:52:31 angelos Exp $

inherit apache-module

KEYWORDS="amd64 x86"

DESCRIPTION="Apache2 bandwidth quota and throttling module."
HOMEPAGE="http://cband.linux.pl/"
SRC_URI="http://cband.linux.pl/download/mod-cband-${PV}.tgz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/mod-cband-${PV}"

DOCFILES="conf/vhosts3.conf.example \
		conf/vhosts2.conf.example \
		conf/vhosts.conf.example \
		Changes AUTHORS doc/*"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="CBAND"

APXS2_ARGS="-DDST_CLASS=3 -c ${PN}.c"

need_apache2
