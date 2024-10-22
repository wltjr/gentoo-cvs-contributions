# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nikto/nikto-1.34-r2.ebuild,v 1.1 2005/05/14 13:44:22 mcummings Exp $

DESCRIPTION="Web Server vulnerability scanner."
HOMEPAGE="http://www.cirt.net/code/nikto.shtml"
SRC_URI="http://www.cirt.net/source/nikto/ARCHIVE/${P}.tar.gz
		http://www.cirt.net/nikto/${P}.man"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
RDEPEND="dev-lang/perl
		>=net-analyzer/nmap-3.00
		ssl? ( dev-libs/openssl )"
IUSE="ssl"

src_compile() {
	sed	-i -e 's:config.txt:nikto.conf:' \
		-i -e 's:\$CFG{configfile}="nikto.conf":\$CFG{configfile}="/etc/nikto/nikto.conf":' \
		 nikto.pl

	mv config.txt nikto.conf

	sed -i -e 's:^#NMAP:NMAP:' \
		-i -e 's:^PROXYHOST:#PROXYHOST:' \
		-i -e 's:^PROXYPORT:#PROXYPORT:' \
		-i -e 's:^PROXYUSER:#PROXYUSER:' \
		-i -e 's:^PROXYPASS:#PROXYPASS:' \
		-i -e 's:# PLUGINDIR=/usr/local/nikto/plugins:PLUGINDIR=/usr/share/nikto/plugins:' \
		 nikto.conf

		 cp ${DISTDIR}/${P}.man ${WORKDIR}/${P}.1
}

src_install() {
	insinto /etc/nikto
	doins nikto.conf

	dodir /usr/bin
	dobin nikto.pl
	dosym /usr/bin/nikto.pl /usr/bin/nikto

	dodir /usr/share/nikto/plugins
	insinto /usr/share/nikto/plugins
	doins plugins/*

	cd docs
	dodoc CHANGES.txt LICENSE.txt README_plugins.txt nikto_usage.txt
	dohtml nikto_usage.html
	doman ${WORKDIR}/${P}.1
}
