# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-radio/gkrellm-radio-2.0.2.ebuild,v 1.2 2003/01/18 18:04:37 mholzer Exp $ 

S=${WORKDIR}/${PN}
DESCRIPTION="A minimalistic GKrellM2 plugin to control radio tuners."
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/gkrellm-radio.phtml"

DEPEND="=app-admin/gkrellm-2*
	>=media-libs/imlib-1.9.14-r1"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc "

src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/lib/gkrellm2/plugins
	doexe radio.so
	dodoc README CHANGES 
}

