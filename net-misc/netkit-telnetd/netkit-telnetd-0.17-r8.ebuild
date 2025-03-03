# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-telnetd/netkit-telnetd-0.17-r8.ebuild,v 1.6 2008/02/05 11:10:40 corsair Exp $

inherit eutils toolchain-funcs

PATCHLEVEL=35
DESCRIPTION="Standard Linux telnet client and server"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
# http://packages.debian.org/stablesource/netkit-telnet
# http://packages.debian.org/testing/source/netkit-telnet
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/netkit-telnet-${PV}.tar.gz
	mirror://debian/pool/main/n/netkit-telnet/netkit-telnet_0.17-${PATCHLEVEL}.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~mips ~ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2
	!net-misc/telnet-bsd"

S=${WORKDIR}/netkit-telnet-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Patch: [0]
	# Gentoo lacks a maintainer for this package right now. And a
	# security problem arose. While reviewing our options for how
	# should we proceed with the security bug we decided it would be
	# better to just stay in sync with debian's own netkit-telnet
	# package. Lots of bug fixes by them over time which were not in
	# our telnetd.
	epatch "${WORKDIR}"/netkit-telnet_0.17-${PATCHLEVEL}.diff

	# Patch: [1]
	# after the deb patch we need to add a small patch that defines
	# gnu source. This is needed for gcc-3.4.x (needs to be pushed
	# back to the deb folk?)
	epatch "${FILESDIR}"/netkit-telnetd-0.17-cflags-gnu_source.patch
}

src_compile() {
	./configure --prefix=/usr || die

	sed -i \
		-e "s:-pipe -O2:${CFLAGS}:" \
		-e "s:-Wpointer-arith::" \
		-e "s:^CC=.*:CC=$(tc-getCC):" \
		-e "s:^CXX=.*:CXX=$(tc-getCXX):" \
		MCONFIG

	make || die
	cd telnetlogin
	make || die
}

src_install() {
	dobin telnet/telnet || die

	dosbin telnetd/telnetd || die
	dosym telnetd /usr/sbin/in.telnetd
	dosbin telnetlogin/telnetlogin || die
	doman telnet/telnet.1
	doman telnetd/*.8
	doman telnetd/issue.net.5
	dosym telnetd.8 /usr/share/man/man8/in.telnetd.8
	doman telnetlogin/telnetlogin.8
	dodoc BUGS ChangeLog README
	dodoc "${FILESDIR}"/net.issue.sample
	newdoc telnet/README README.telnet
	newdoc telnet/TODO TODO.telnet
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/telnetd.xinetd telnetd
}
