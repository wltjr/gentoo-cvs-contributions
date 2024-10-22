# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/bridge-utils/bridge-utils-1.4.ebuild,v 1.1 2008/06/05 17:47:34 robbat2 Exp $

inherit toolchain-funcs eutils autotools

DESCRIPTION="Tools for configuring the Linux kernel 802.1d Ethernet Bridge"
HOMEPAGE="http://bridge.sourceforge.net/"
SRC_URI="mirror://sourceforge/bridge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/os-headers"
RDEPEND=""

get_headers() {
	CTARGET=${CTARGET:-${CHOST}}
	dir=/usr/include
	tc-is-cross-compiler && dir=/usr/${CTARGET}/usr/include
	echo "${dir}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	# use santitized headers and not headers from /usr/src
	econf \
		--prefix=/ \
		--libdir=/usr/$(get_libdir) \
		--includedir=/usr/include \
		--with-linux-headers="$(get_headers)" \
		|| die "econf failed"
	emake || die "make failed"
}

src_install () {
	emake install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog README THANKS TODO
	dodoc doc/{FAQ,FIREWALL,HOWTO,PROJECTS,RPM-GPG-KEY,SMPNOTES,WISHLIST}
}

pkg_postinst () {
	ewarn "This package no longer provides a seperate init script."
	ewarn "Please utilize the new bridge support in baselayout."
}
