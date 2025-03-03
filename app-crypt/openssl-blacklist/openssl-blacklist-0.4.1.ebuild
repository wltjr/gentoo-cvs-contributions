# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/openssl-blacklist/openssl-blacklist-0.4.1.ebuild,v 1.2 2008/07/28 06:52:41 cla Exp $

DESCRIPTION="Detection of weak ssl keys produced by certain debian versions between 2006 and 2008"
HOMEPAGE="https://launchpad.net/ubuntu/+source/openssl-blacklist/"
SRC_URI="mirror://debian/pool/main/o/${PN}/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa x86 ~x86-fbsd"
IUSE=""
DEPEND="dev-lang/python"
S="${WORKDIR}/trunk"

src_compile() {
	einfo nothing to compile
}

src_install() {
	dobin openssl-vulnkey || die "dobin failed"
	doman openssl-vulnkey.1 || die "doman failed"
	dodir /usr/share/openssl-blacklist/
	for keysize in 512 1024 2048 4096; do \
		cat "${S}/debian/blacklist.prefix" > "${D}/usr/share/openssl-blacklist/blacklist.RSA-$keysize"
		cat "${S}"/blacklists/*/blacklist-$keysize.db \
			| cut -d ' ' -f 5 | cut -b21- | sort \
			>> "${D}/usr/share/openssl-blacklist/blacklist.RSA-$keysize"
	done

}
