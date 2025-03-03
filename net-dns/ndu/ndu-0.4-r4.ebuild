# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ndu/ndu-0.4-r4.ebuild,v 1.4 2007/04/22 13:56:11 dertobi123 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="DNS serial number incrementer and reverse zone builder"
SRC_URI="http://uranus.it.swin.edu.au/~jn/linux/${P}.tar.gz"
HOMEPAGE="http://uranus.it.swin.edu.au/~jn/linux/dns.htm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
DEPEND="sys-apps/sed
		virtual/libc"
RDEPEND="virtual/libc
		sys-apps/ed" # dnstouch calls ed to do the dirty work

src_unpack() {
	unpack ${A}

	epatch ${FILESDIR}/${P}-binary-locations.patch

	cd ${S}/src
	# use the correct compiler
	sed -e 's|gcc|$(CXX)|g' -i Makefile
	# set correct config pathes
	sed -e 's|#define CONFIG_PATH "/etc/"|#define CONFIG_PATH "/etc/bind/"|g' -i ndu.cpp
	sed -e 's|"/etc/ndu.conf"|"/etc/bind/ndu.conf"|g' -i dnstouch.cpp
	# hack up something to work around bug #73858
	sed -e 's|execlp("ed", "ed", filename, 0);|execlp("ed", "ed", "-s", filename, 0);|g' -i dnstouch.cpp
	# use the correct editor
	sed -e 's|VISUAL|EDITOR|g' -i dnsedit

	cd ${S}
	# match our bind config
	sed -e 's|0.0.127.in-addr.arpa|127.in-addr.arpa|g' -i ndu.conf
	# document the support for the chrooted BIND setup
	echo '// if you use a chrooted setup, then you need to uncomment these lines:' >>ndu.conf
	echo '//process "/chroot/dns/named.conf"' >>ndu.conf
	echo '//chroot "/chroot/dns"' >>ndu.conf
}

src_compile() {
	cd ${S}/src
	emake CFLAGS="${CFLAGS}" CXX="$(tc-getCXX)"
}

src_install () {
	into /usr
	dobin src/{dnsedit,ndu,dnstouch}
	into /
	insinto /etc/bind
	doins ndu.conf
	dodoc README INSTALL
}
