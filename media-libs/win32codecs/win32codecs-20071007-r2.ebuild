# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/win32codecs/win32codecs-20071007-r2.ebuild,v 1.2 2007/11/08 07:57:15 opfer Exp $

inherit multilib

DESCRIPTION="Win32 binary codecs for video and audio playback support"
SRC_URI="mirror://mplayer/releases/codecs/all-${PV}.tar.bz2"
HOMEPAGE="http://www.mplayerhq.hu/"
LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 x86 ~x86-fbsd"
IUSE="real"

RDEPEND="real? ( =virtual/libstdc++-3.3*
	amd64? ( media-video/realplayer ) )"

S="${WORKDIR}/all-${PV}"

RESTRICT="strip"

QA_TEXTRELS="usr/$(get_libdir)/real/drvc.so
	usr/$(get_libdir)/real/drv[34].so.6.0
	usr/$(get_libdir)/win32/vid_*.xa"

pkg_setup() {
	# This is a binary x86 package => ABI=x86
	# Please keep this in future versions
	# Daniel Gryniewicz <dang@gentoo.org>
	has_multilib_profile && ABI="x86"
}

src_install() {
	cd "${S}"

	# see #83221
	insopts -m0644
	dodir /usr/$(get_libdir)/win32

	if use real
	then
		dodir /usr/$(get_libdir)/real
		insinto /usr/$(get_libdir)/real
		doins *so.6.0

		# copy newly introduced codecs from realplayer10
		# see the ChangeLog online
		doins *.so

		# fix bug #80321
		ln -s "${D}"/usr/$(get_libdir)/real/* "${D}"/usr/$(get_libdir)/win32/
	fi

	insinto /usr/$(get_libdir)/win32

	doins *.dll *.ax *.xa *.acm *.vwp *.drv *.DLL

	dodoc README

	dodir /etc/revdep-rebuild
	cat - > "${D}/etc/revdep-rebuild/50win32codecs" <<EOF
SEARCH_DIRS_MASK="/usr/$(get_libdir)/real /usr/$(get_libdir)/win32"
EOF
}
