# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/alsa-lib/alsa-lib-1.0.7.ebuild,v 1.7 2005/01/22 06:40:02 vapier Exp $

inherit libtool eutils

DESCRIPTION="Advanced Linux Sound Architecture Library"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/lib/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE="static jack doc"

RDEPEND="virtual/alsa
	>=media-sound/alsa-headers-${PV}"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.2.6 )"

PDEPEND="jack? ( =media-plugins/alsa-jack-${PV}* )"

src_unpack() {
	unpack ${A}

	if use static; then
		mv ${S} ${S}.static
		unpack ${A}

		cd ${S}.static
		epatch ${FILESDIR}/${P}-pcm_wait.patch
		elibtoolize
	fi

	cd ${S}
	epatch ${FILESDIR}/${P}-pcm_wait.patch
	elibtoolize
}

src_compile() {
	local myconf=""

	# needed to avoid gcc looping internaly
	use hppa && export CFLAGS="-O1 -pipe"

	econf --enable-static=no --enable-shared=yes || die
	emake || die

	if use doc; then
		emake doc || die
	fi

	# Can't do both according to alsa docs and bug #48233
	if use static; then
		cd ${S}.static
		econf --enable-static=yes --enable-shared=no || die
		emake || die
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	preserve_old_lib /usr/$(get_libdir)/libasound.so.1

	dodoc ChangeLog COPYING TODO
	use doc && dohtml -r doc/doxygen/html/*

	if use static; then
		cd ${S}.static
		make DESTDIR="${D}" install || die "make install failed"
	fi
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libasound.so.1

	einfo "If you are using an emu10k1 based sound card, and you are upgrading"
	einfo "from a version of alsalib <1.0.6, you will need to recompile packages"
	einfo "that link against alsa-lib due to some ABI changes between 1.0.5 and"
	einfo "1.0.6 unique to that hardware. See the following URL for more information:"
	einfo "http://bugs.gentoo.org/show_bug.cgi?id=65347"
}
