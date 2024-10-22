# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-radio/gkrellm-radio-2.0.4.ebuild,v 1.7 2007/07/11 20:39:22 mr_bones_ Exp $

inherit gkrellm-plugin

IUSE="lirc"

S=${WORKDIR}/${PN}
DESCRIPTION="A minimalistic GKrellM2 plugin to control radio tuners."
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/gkrellm-radio.phtml"

DEPEND="lirc? ( app-misc/lirc )"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="ppc sparc x86"

PLUGIN_SO=radio.so

src_compile() {
	use lirc && myconf="${myconf} WITH_LIRC=1"
	emake ${myconf} || die
}
