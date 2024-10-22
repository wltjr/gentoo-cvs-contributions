# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/yiff/yiff-2.14.5.ebuild,v 1.7 2007/03/18 13:03:04 nixnut Exp $

inherit flag-o-matic eutils kde-functions

DESCRIPTION="high performance and stable sound server for UNIX games and apps"
HOMEPAGE="http://wolfpack.twu.net/YIFF/"
SRC_URI="ftp://wolfpack.twu.net/users/wolfpack/${P}.tar.bz2"
RESTRICT="strip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="alsa gtk kde"

DEPEND="gtk? ( =x11-libs/gtk+-1.2* )
	alsa? ( media-libs/alsa-lib )
	kde? ( || ( kde-base/kmid kde-base/kdemultimedia ) )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	if use kde; then
		set-kdedir
		sed -i "/^LIB =/s:$: -L${KDEDIR}/lib -lkmid:" yiff/Makefile.Linux
	fi
	sed -i \
		-e "/^YLIB_DIR/s:/lib:/$(get_libdir):" \
		-e '/LDCONFIG/s:=.*:=true:' \
		-e '/MAN_DIR/s:/man/:/share/man/:' \
		*/Makefile* || die
}

src_compile() {
	local pkgs="libY2 yiff yiffutils"
	use gtk && pkgs="${pkgs} yiffconfig"
	use kde && append-flags -DHAVE_LIBKMID -I${KDEDIR}/include
	use alsa && append-flags -DALSA_RUN_CONFORM
	append-flags -DOSS -DOSS_BUFFRAG -DYSHM_SUPPORT -D__USE_BSD
	emake linux \
		CFLAGS="${CFLAGS}" \
		LINUX_DIRS="${pkgs}" \
		|| die
}

src_install() {
	make install PREFIX="${D}"/usr || die
	dodoc AUTHORS README
}
