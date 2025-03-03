# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gnump3d/gnump3d-3.0.ebuild,v 1.5 2007/11/30 21:32:11 beandog Exp $

inherit eutils multilib

MY_PV=${PV/9/9final}
MY_P=${PN}-${MY_PV}

DESCRIPTION="A streaming server for MP3, OGG vorbis and other streamable files"
HOMEPAGE="http://www.gnump3d.org/"
SRC_URI="http://savannah.gnu.org/download/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ppc64 sparc x86"
IUSE=""

DEPEND="sys-apps/sed
	dev-lang/perl"

RESTRICT="test"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	enewuser gnump3d '' '' '' nogroup || die "Failed to add new user."
	LIBDIR=/usr/$(get_libdir)
}

src_compile() { :; }

src_install() {
	PERLDIR="`perl bin/getlibdir`"

	insinto ${PERLDIR}/gnump3d
	doins lib/gnump3d/*.pm
	insinto ${PERLDIR}/gnump3d/plugins
	doins lib/gnump3d/plugins/*.pm
	insinto ${PERLDIR}/gnump3d/lang
	doins lib/gnump3d/lang/*.pm

	dobin bin/gnump3d2 bin/gnump3d-top bin/gnump3d-index
	dosym /usr/bin/gnump3d2 /usr/bin/gnump3d
	doman man/*.1

	insinto /usr/share/gnump3d
	doins -r templates/*

	insinto /etc/gnump3d
	doins etc/gnump3d.conf etc/mime.types etc/file.types
	dosed "s,PLUGINDIR,${PERLDIR},g" /etc/gnump3d/gnump3d.conf
	dosed 's,^user *= *\(.*\)$,user = gnump3d,g' /etc/gnump3d/gnump3d.conf

	dodoc AUTHORS ChangeLog DOWNSAMPLING PLUGINS README SUPPORT TODO

	newinitd "${FILESDIR}"/${PN}.init.d gnump3d
	newconfd "${FILESDIR}"/${PN}.conf.d gnump3d

	keepdir /var/log/gnump3d
	keepdir /var/cache/gnump3d/serving

	fowners gnump3d:nogroup /var/log/gnump3d /var/cache/gnump3d
}

pkg_postinst() {
	einfo
	elog "Please edit your /etc/gnump3d/gnump3d.conf before running"
	elog "/etc/init.d/gnump3d start"
	einfo
}
