# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-rack/jack-rack-1.4.3.ebuild,v 1.8 2004/06/17 07:16:22 eradicator Exp $

IUSE="gnome"

inherit eutils

DESCRIPTION="JACK Rack is an effects rack for the JACK low latency audio API."
HOMEPAGE="http://arb.bash.sh/~rah/software/jack-rack/"
SRC_URI="http://arb.bash.sh/~rah/software/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86 ~ppc amd64"

DEPEND="media-libs/ladcca \
	media-libs/liblrdf \
	>=x11-libs/gtk+-2.0.6-r2 \
	>=media-libs/ladspa-sdk-1.12 \
	dev-libs/libxml2 \
	media-sound/jack-audio-connection-kit"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gtkdep.patch
}

src_compile() {
	econf `use_enable gnome` || die "econf failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
}
