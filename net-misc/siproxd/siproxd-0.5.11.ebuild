# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/siproxd/siproxd-0.5.11.ebuild,v 1.3 2007/04/28 17:02:04 swegener Exp $

inherit eutils

IUSE="static doc"

DESCRIPTION="masquerading SIP proxy"
HOMEPAGE="http://siproxd.sourceforge.net/"
SRC_URI="mirror://sourceforge/siproxd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=net-libs/libosip-2.0.0
	doc? ( app-text/docbook-sgml-utils )"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-configure-docs.diff

	# re-create configure (stolen from dhcpd :)
	einfo "Re-creating configure..."
	autoreconf -fi || die "autoreconf failed"

	# Make the daemon run as user 'siproxd' by default
	sed -i -e "s:nobody:siproxd:" doc/siproxd.conf.example
}

src_compile() {
	local myconf

	use static && \
		myconf="--enable-static"

	econf ${myconf} \
		`use_enable doc docs` || die "configure failed"

	emake || die "make failed"
}

src_install() {
	einstall || die "install failed"

	newinitd ${FILESDIR}/siproxd.rc6 siproxd

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO RELNOTES

	# Set up siproxd directories
	keepdir /var/lib/siproxd
	keepdir /var/run/siproxd
}

pkg_postinst() {
	enewgroup siproxd
	enewuser siproxd -1 -1 /dev/null siproxd

	fowners siproxd:siproxd /var/lib/siproxd
	fowners siproxd:siproxd /var/run/siproxd
}
