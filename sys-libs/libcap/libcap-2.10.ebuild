# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcap/libcap-2.10.ebuild,v 1.1 2008/06/01 02:28:26 vapier Exp $

inherit eutils multilib toolchain-funcs pam

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="http://www.friedhoff.org/posixfilecaps.html"
SRC_URI="http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap${PV:0:1}/${P}.tar.bz2"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="pam"

RDEPEND="sys-apps/attr"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

src_unpack() {
	unpack ${P}.tar.bz2
	cd "${S}"
	epatch "${FILESDIR}"/${PV}/*.patch
	epatch "${FILESDIR}"/${PN}-2.08-no-static.patch
	sed -i 's:gperf:false:' libcap/Makefile #210424

	sed -i -e '/cap_setfcap.*morgan/s:^:#:' pam_cap/capability.conf
}

src_compile() {
	tc-export BUILD_CC CC AR RANLIB
	export PAM_CAP=$(use pam && echo yes || echo no)
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" lib=$(get_libdir) || die

	gen_usr_ldscript libcap.so
	mv "${D}"/$(get_libdir)/libcap.a "${D}"/usr/$(get_libdir)/ || die

	dopammod pam_cap/pam_cap.so
	dopamsecurity '' pam_cap/capability.conf

	dodoc CHANGELOG README doc/capability.notes
}
