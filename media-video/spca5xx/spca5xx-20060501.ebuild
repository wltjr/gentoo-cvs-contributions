# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/spca5xx/spca5xx-20060501.ebuild,v 1.4 2007/11/27 12:12:51 zzam Exp $

inherit linux-mod

DESCRIPTION="spca5xx driver for webcams."
HOMEPAGE="http://mxhaard.free.fr/spca5xx.html"
SRC_URI="http://mxhaard.free.fr/spca50x/Download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RESTRICT=""
DEPEND=""
RDEPEND=""

MODULE_NAMES="spca5xx(usb/video:)"
BUILD_TARGETS="default"
CONFIG_CHECK="VIDEO_DEV"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
}

src_unpack() {
	unpack ${A}
	convert_to_m "${S}"/Makefile
	cd "${S}"
	epatch "${FILESDIR}"/spca-20060501-defines.patch
}

src_install() {
	dodoc CHANGELOG INSTALL README
	linux-mod_src_install
}
