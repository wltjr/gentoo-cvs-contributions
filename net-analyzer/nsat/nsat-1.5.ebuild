# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nsat/nsat-1.5.ebuild,v 1.16 2007/07/22 07:59:37 pva Exp $

inherit eutils

DESCRIPTION="Network Security Analysis Tool, an application-level network security scanner"
HOMEPAGE="http://nsat.sourceforge.net/"
SRC_URI="mirror://sourceforge/nsat/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc sparc x86"
IUSE="X"

RDEPEND="X? ( x11-libs/libX11
		dev-lang/tk )
	net-libs/libpcap"

DEPEND="$RDEPEND >=sys-devel/autoconf-2.58"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-configure.patch
	# bug 128204
	epatch "${FILESDIR}"/${P}-lvalue-gcc4.patch

	sed -i "s:^#CGIFile /usr/local/share/nsat/nsat.cgi$:#CGIFile /usr/share/nsat/nsat.cgi:g" \
		nsat.conf
	sed -i "s:/usr/local:/usr:g" Makefile.in
	sed -i "s:/usr/local:/usr:g" tools/xnsat
	sed -i -e "s:/usr/local/share/nsat/nsat.conf:/etc/nsat/nsat.conf:g" \
		-e "s:/usr/local/share/nsat/nsat.cgi:/usr/share/nsat/nsat.cgi:g" \
		src/lang.h
}

src_compile() {
	WANT_AUTOCONF=2.5
	autoconf

	econf $( use_with X x ) || die

	make|| die "compile problem"
}

src_install () {
	dobin nsat smb-ns
	use X && dobin tools/xnsat

	insinto /usr/share/nsat
	doins nsat.cgi

	insinto /etc/nsat
	doins nsat.conf

	dodoc README doc/CHANGES
	doman doc/nsat.8
}
