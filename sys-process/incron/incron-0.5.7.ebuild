# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/incron/incron-0.5.7.ebuild,v 1.2 2008/06/01 10:20:48 hollow Exp $

inherit eutils linux-info toolchain-funcs

DESCRIPTION="inotify based cron daemon"
HOMEPAGE="http://incron.aiken.cz/"
SRC_URI="http://inotify.aiken.cz/download/incron/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

CONFIG_CHECK="INOTIFY"
ERROR_INOTIFY="Recompile your kernel with inotify support - CONFIG_INOTIFY"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	emake CXX=$(tc-getCXX) CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
