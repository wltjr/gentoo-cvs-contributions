# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/pnetlib/pnetlib-0.6.0.ebuild,v 1.3 2003/10/17 14:10:47 scandium Exp $

inherit eutils

DESCRIPTION="Portable .NET C# library"
HOMEPAGE="http://www.dotgnu.org/"
SRC_URI="mirror://gnu/dotgnu-pnet/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"

IUSE="X"

DEPEND="=dev-dotnet/pnet-${PV}*
	X? ( virtual/x11 )"

src_unpack() {
	# A fix for foreign language support
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/pnetlib-0.6.0.resources.patch
	autoconf
	automake
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog HACKING INSTALL NEWS README
	dodoc doc/*.txt
	dohtml doc/*.html
}
