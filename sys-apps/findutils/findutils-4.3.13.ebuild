# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/findutils/findutils-4.3.13.ebuild,v 1.6 2008/06/22 15:28:06 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs multilib

SELINUX_PATCH="findutils-4.3.12-selinux.diff"

DESCRIPTION="GNU utilities for finding files"
HOMEPAGE="http://www.gnu.org/software/findutils/"
# SRC_URI="mirror://gnu/${PN}/${P}.tar.gz mirror://gentoo/${P}.tar.gz"
SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="nls selinux static"

RDEPEND="selinux? ( sys-libs/libselinux )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Don't build or install locate because it conflicts with slocate,
	# which is a secure version of locate.  See bug 18729
	sed -i '/^SUBDIRS/s/locate//' Makefile.in

	use selinux && epatch "${FILESDIR}/${SELINUX_PATCH}"
}

src_compile() {
	use static && append-ldflags -static

	local myconf
	use userland_GNU || myconf=" --program-prefix=g"

	if echo "#include <regex.h>" | $(tc-getCPP) > /dev/null ; then
		myconf="${myconf} --without-included-regex"
	fi

	econf \
		$(use_enable nls) \
		--libexecdir=/usr/$(get_libdir)/find \
		${myconf} \
		|| die "configure failed"
	emake AR="$(tc-getAR)" || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS README TODO ChangeLog
}
