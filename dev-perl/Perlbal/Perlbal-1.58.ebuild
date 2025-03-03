# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Perlbal/Perlbal-1.58.ebuild,v 1.4 2008/07/06 19:37:53 robbat2 Exp $

inherit perl-module

DESCRIPTION="Reverse-proxy load balancer and webserver"
HOMEPAGE="http://www.danga.com/perlbal/"
SRC_URI="mirror://cpan/authors/id/B/BR/BRADFITZ/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-perl/libwww-perl
		>=dev-perl/Danga-Socket-1.57
		dev-perl/Sys-Syscall
		dev-perl/BSD-Resource
		dev-lang/perl"
#SRC_TEST="do" # testing not available on Perlbal yet ;-)
mydoc="CHANGES"

PATCHES=( "${FILESDIR}/${PN}-1.58-Use-saner-name-in-process-listing.patch" )

src_install() {
	perl-module_src_install || die "perl-module_src_install failed"
	cd "${S}"
	dodoc doc/*.txt
	docinto hacking
	dodoc doc/hacking/*.txt
	docinto conf
	dodoc conf/*.{dat,conf}
	keepdir /etc/perlbal
	newinitd "${FILESDIR}"/perlbal_init.d_1.58 perlbal
	newconfd "${FILESDIR}"/perlbal_conf.d_1.58 perlbal
}

pkg_postinst() {
	perl-module_pkg_postinst
	einfo "Please see the example configuration files located"
	einfo "within /usr/share/doc/${PF}/conf/"
}
