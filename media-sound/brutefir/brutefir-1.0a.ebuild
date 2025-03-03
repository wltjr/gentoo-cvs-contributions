# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/brutefir/brutefir-1.0a.ebuild,v 1.9 2007/01/05 17:25:14 flameeyes Exp $

IUSE=""

inherit eutils

DESCRIPTION="Software convolution engine for applying long FIR filters"
HOMEPAGE="http://www.ludd.luth.se/~torger/brutefir.html"
SRC_URI="http://www.ludd.luth.se/~torger/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"

DEPEND=">=media-libs/alsa-lib-0.9.1
	media-sound/jack-audio-connection-kit
	>=sci-libs/fftw-3.0.0"

src_compile() {
	emake || die
}

src_install() {

	mkdir -p ${D}/usr/bin
	mkdir -p ${D}/usr/lib/brutefir

	einstall DESTDIR=${D} \
		INSTALL_PREFIX=${D}/usr	|| die

	if [ "$(get_libdir)" != "lib" ]; then
		mv ${D}/usr/lib ${D}/usr/$(get_libdir)
	fi

	dodoc CHANGES README LICENSE

	insinto usr/share/brutefir
	doins xtc_config directpath.txt crosspath.txt massive_config bench1_config bench2_config bench3_config bench4_config bench5_config
}

pkg_postinst() {
	elog Brutefir is a complicated piece of software. Please read the documentation first!
	elog You can find documentation here: http://www.ludd.luth.se/~torger/brutefir.html
	elog Example config files are in /usr/share/brutefir
}
