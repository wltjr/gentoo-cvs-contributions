# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dazuko/dazuko-2.3.5_pre1.ebuild,v 1.1 2008/02/23 10:33:35 alonbl Exp $

inherit linux-mod toolchain-funcs flag-o-matic

DESCRIPTION="Linux kernel module and interface providing file access control"
MY_P="${P/_/-}" # for -preN versions
SRC_URI="http://www.dazuko.org/files/${MY_P}.tar.gz"
HOMEPAGE="http://www.dazuko.org"
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND="kernel_linux? (
	>=virtual/linux-sources-2.6.20
	>=sys-fs/redirfs-0.2
)"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

pkg_setup() {
	[ "${KERNEL}" = "linux" ] && linux-mod_pkg_setup
	# kernel settings
	if [ "${KERNEL}" = "linux" ] && kernel_is le 2 4; then
		BUILD_TARGETS="all"
	else
		EXTRA_CONFIG="--enable-redirfs"
		BUILD_TARGETS="dummy_rule"
	fi
	MODULE_NAMES="dazuko(misc:)"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-redirfs.patch"
}

src_compile() {
	if [ "${KERNEL}" = "FreeBSD" ]; then
		KERNEL_DIR=/usr/src/sys
		KBUILD_OUTPUT=/boot/modules
		MAKE=make
	fi
	./configure \
		--without-dep \
		--kernelsrcdir="${KERNEL_DIR}" \
		--kernelobjdir="${KBUILD_OUTPUT}" \
		${EXTRA_CONFIG} \
		|| die "configure failed"

	if [ "${KERNEL}" = "linux" ]; then
		convert_to_m Makefile
		linux-mod_src_compile
	else
		emake CC="$(tc-getCC)" LD="$(tc-getLD)" LDFLAGS="$(raw-ldflags)" || die
	fi

	emake -C library CC="$(tc-getCC)" || die
}

src_install() {
	if [ "${KERNEL}" = "linux" ]; then
		linux-mod_src_install
	else
		insinto /boot/modules
		doins "${S}"/dazuko.kld
		exeinto /boot/modules
		doexe "${S}"/dazuko.ko
	fi

	dolib.a library/libdazuko.a
	insinto /usr/include
	doins dazukoio.h
	doins dazuko_events.h

	dodoc README*
}

src_test() {
	if [ "${EUID}" != 0 ]; then
		ewarn "Cannot test while not root"
	else
		emake test || die "Test failed"
	fi
}

pkg_postinst() {
	[ "${KERNEL}" = "linux" ] && linux-mod_pkg_postinst
}

pkg_postrm() {
	[ "${KERNEL}" = "linux" ] && linux-mod_pkg_postrm
}
