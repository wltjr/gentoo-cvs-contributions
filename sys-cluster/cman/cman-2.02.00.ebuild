# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/cman/cman-2.02.00.ebuild,v 1.2 2008/03/17 23:39:06 xmerlin Exp $

inherit eutils versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2).$(get_version_component_range 3)"

DESCRIPTION="general-purpose symmetric cluster manager"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-kernel/linux-headers-2.6.23
	=sys-cluster/openais-0.82*
	=sys-cluster/ccs-${CLUSTER_RELEASE}*
	=sys-cluster/cman-lib-${CLUSTER_RELEASE}*
	!sys-cluster/cman-headers
	!sys-cluster/cman-kernel
	!sys-cluster/dlm-headers
	!sys-cluster/magma
	!sys-cluster/magma-plugins
	"

RDEPEND="${DEPEND}"

PDEPEND="=sys-cluster/dlm-${CLUSTER_RELEASE}*
	=sys-cluster/fence-${CLUSTER_RELEASE}*"

S="${WORKDIR}/${MY_P}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix the manual pages have executable bit
	sed -i -e '
		/\tinstall -d/s/install/& -m 0755/; t
		/\tinstall/s/install/& -m 0644/' \
		man/Makefile || die "failed patching man pages permission"

	epatch "${FILESDIR}"/${P}-include.patch || die
}

src_compile() {
	(cd "${WORKDIR}"/${MY_P};
		./configure \
			--cc=$(tc-getCC) \
			--cflags="-Wall" \
			--disable_kernel_check \
			--release_major="$MAJ_PV" \
			--release_minor="$MIN_PV" \
			--cmanlibdir=/usr/lib \
			--cmanincdir=/usr/include \
	) || die "configure problem"

	emake clean
	emake -C cman_tool || die "compile problem"
	emake -C daemon || die "compile problem"
	env -u CFLAGS emake -C qdisk || die "compile problem"
	emake -C init.d || die "compile problem"
	emake -C man || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "install problem"

	# These were installed by cman-lib.
	rm "${D}"/usr/lib/libcman.so.${PV} \
		"${D}"/usr/lib/libcman.a \
		"${D}"/usr/include/libcman.h \
		"${D}"/usr/lib/libcman.so.2 \
		"${D}"/usr/lib/libcman.so \
		|| die "failed to cleanup extra files"

	newinitd "${FILESDIR}"/${PN}-2.0x.rc ${PN} || die
	newconfd "${FILESDIR}"/${PN}-2.0x.conf ${PN} || die
	newinitd "${FILESDIR}"/qdiskd-2.0x.rc qdiskd || die

	keepdir /etc/cluster || die
}

pkg_postinst() {
	einfo ""
	einfo "Please add a cluster.conf in /etc/cluster/"
	einfo ""
	einfo "If you want to use cman and dlm 2.0x.00"
	einfo "with 2.6.20 kernels you have to patch your"
	einfo "kernel sources with:"
	einfo "http://dev.gentoo.org/~xmerlin/gfs/dlm-gfs-2.6.20.patch.bz2"
	einfo ""
}
