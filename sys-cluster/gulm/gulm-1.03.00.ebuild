# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/gulm/gulm-1.03.00.ebuild,v 1.4 2007/07/29 22:32:37 robbat2 Exp $

inherit linux-mod

MY_P="cluster-${PV}"
DESCRIPTION="Redundant server-based cluster and lock manager for GFS"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

IUSE=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=sys-cluster/ccs-1.03.00
	>=sys-cluster/cman-1.03.00
	sys-apps/tcp-wrappers
	"

RDEPEND="sys-apps/tcp-wrappers"

S="${WORKDIR}/${MY_P}/${PN}"

src_compile() {
	./configure --kernel_src=/usr/src/linux || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	emake DESTDIR=${D} install || die "install problem"

	rm -f ${D}/etc/init.d/lock_gulmd
}
