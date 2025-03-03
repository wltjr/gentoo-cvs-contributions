# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/magma/magma-1.02.00-r1.ebuild,v 1.5 2007/03/09 09:05:14 xmerlin Exp $

inherit eutils

CLUSTER_RELEASE="1.02.00"
MY_P="cluster-${CLUSTER_RELEASE}"
CVS_RELEASE="20060713"

DESCRIPTION="Magma cluster interface"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz
	mirror://gentoo/${PN}-${PV}-${CVS_RELEASE}-cvs.patch.gz
	http://dev.gentoo.org/~xmerlin/gfs/${PN}-${PV}-${CVS_RELEASE}-cvs.patch.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${PN}-${PV}-${CVS_RELEASE}-cvs.patch || die
	epatch ${FILESDIR}/${PN}-1.00.00-compile.patch || die
}

src_compile() {
	./configure || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	emake DESTDIR=${D} install || die "install problem"
	dodoc doc/*
}
