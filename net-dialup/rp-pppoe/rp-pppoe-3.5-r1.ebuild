# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/rp-pppoe/rp-pppoe-3.5-r1.ebuild,v 1.3 2004/08/28 03:58:20 vapier Exp $

inherit eutils

DESCRIPTION="A user-mode PPPoE client and server suite for Linux"
SRC_URI="http://www.roaringpenguin.com/pppoe/${P}.tar.gz"
HOMEPAGE="http://www.roaringpenguin.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa mips ppc sparc x86"
IUSE="X"

DEPEND=">=net-dialup/ppp-2.4.1
	X? ( virtual/x11 )"

src_unpack() {
	unpack ${A} || die
	cd ${S} || die

	# Patch to enable integration of adsl-start and adsl-stop with
	# net.eth0 so that the pidfile can be found reliably per interface
	epatch ${FILESDIR}/rp-pppoe-3.5-pidfile.patch
}

src_compile() {
	addpredict /dev/ppp

	# sanbdox violation workaround
	cd ${S}/src
	sed -i -e 's/modprobe/#modprobe/' configure || die "sed failed"
	econf || die "econf failed"
	emake || die "emake failed"

	if use X; then
		make -C ${S}/gui || die "gui make failed"
	fi
}

src_install () {
	cd ${S}/src
	make RPM_INSTALL_ROOT=${D} docdir=/usr/share/doc/${PF} install \
		|| die "install failed"
	prepalldocs

	if use X; then
		make -C ${S}/gui install RPM_INSTALL_ROOT=${D} \
		datadir=/usr/share/doc/${PF}/ || die "gui install failed"
		dosym /usr/share/doc/${PF}/tkpppoe /usr/share/tkpppoe
	fi

	exeinto /etc/init.d ; newexe ${FILESDIR}/rp-pppoe.rc rp-pppoe
}

pkg_postinst() {
	einfo "Use adsl-setup to configure your dialup connection"
}
