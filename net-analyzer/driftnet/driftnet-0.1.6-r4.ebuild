# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/driftnet/driftnet-0.1.6-r4.ebuild,v 1.3 2008/05/16 18:23:23 nixnut Exp $

inherit eutils flag-o-matic

MY_P="${PN}_${PV}"
DESCRIPTION="A program which listens to network traffic and picks out images from TCP streams it observes"
HOMEPAGE="http://www.ex-parrot.com/~chris/driftnet/"
SRC_URI="mirror://debian/pool/main/d/driftnet/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/d/driftnet/${MY_P}-8.diff.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ppc -sparc x86"
SLOT="0"
IUSE="gtk"

RDEPEND="media-libs/jpeg
	media-libs/giflib
	media-libs/libpng
	net-libs/libpcap
	gtk? ( >=x11-libs/gtk+-2.0.0 )"

DEPEND="${RDEPEND}
	>=x11-misc/makedepend-1.0.0
	dev-util/pkgconfig"

S="${WORKDIR}/${P}.orig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${DISTDIR}"/${MY_P}-8.diff.gz

	# don't use gtk+ by default
	sed -i 's:^\(.*gtk-config.*\)$:#\1:g' Makefile || die "sed disable gtk failed"
}

src_compile() {
	append-ldflags $(bindnow-flags)

	if use gtk; then
		sed -i 's:^#\(.*gtk-config.*\)$:\1:g' Makefile || die "sed enable gtk failed"
		emake || die "gtk+ build failed"
		mv driftnet driftnet-gtk
		make clean || die
	else
		append-flags -DNO_DISPLAY_WINDOW
	fi

	emake || die "emake failed"
}

src_install () {
	dobin driftnet || die "dobin failed"
	doman driftnet.1 || die "doman failed"

	use gtk && { dobin driftnet-gtk || die "dobin failed (gtk)" ; }

	dodoc CHANGES CREDITS README TODO || die "dodoc failed"

	elog "marking the no-display driftnet as setuid root."
	chown root:wheel "${D}/usr/bin/driftnet"
	chmod 750 "${D}/usr/bin/driftnet"
	chmod u+s "${D}/usr/bin/driftnet"
}

pkg_postinst() {
	if ! has_version 'virtual/mpg123' ; then
		elog
		elog "In case you want driftnet to be able to play"
		elog "audio files found on the streams, you need to do:"
		elog " # emerge mpg123"
		elog
	fi
}
