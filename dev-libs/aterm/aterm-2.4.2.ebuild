# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/aterm/aterm-2.4.2.ebuild,v 1.2 2006/03/21 22:15:36 ferdy Exp $

inherit flag-o-matic

DESCRIPTION="ATerm tree-handling library"
HOMEPAGE="http://www.cwi.nl/projects/MetaEnv/aterm/"
SRC_URI="http://www.cwi.nl/projects/MetaEnv/aterm/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"
IUSE="java"

DEPEND="java? ( virtual/jdk )"

src_compile() {
	local myc
	use java && myc="--with-java" || myc="--without-java"

	filter-flags "-fomit-frame-pointer"
	# 2004-06-11: karltk
	# May want to add 64bit support on some archs?
	# Cannot do --without-64bit on 32bit arch
	econf \
		--with-gcc \
		--with-cflags="${CFLAGS}" \
		--without-dbg \
		--with-prof \
		${myconf} || die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
