# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/xmule/xmule-1.8.2-r1.ebuild,v 1.1 2004/05/15 18:07:22 mholzer Exp $

MY_P=${P}b
S=${WORKDIR}/${MY_P}

DESCRIPTION="wxWindows based client for the eDonkey/eMule/lMule network"
HOMEPAGE="http://home.gna.org/xmule/start.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
#KEYWORDS="~x86 ~amd64 ~ppc"

IUSE="nls"

DEPEND=">=x11-libs/wxGTK-2.4.1
	nls? ( sys-devel/gettext )
	>=sys-libs/zlib-1.2.1"

pkg_setup() {
	# FIXME: Is this really how we want to do this ?
	GREP=`grep ' unicode' /var/db/pkg/x11-libs/wxGTK*/USE`
	if [ "${GREP}" != "" ]; then
		eerror "This package doesn't work with wxGTK"
		eerror "compiled with gtk2 and unicode in USE"
		eerror "Please re-compile wxGTK with -unicode"
		die "aborting..."
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's/@datadir@/${DESTDIR}@datadir@/' Makefile.in
}

src_compile () {
	export WANT_AUTOCONF=2.5
	WANT_AUTOMAKE=1.7
	aclocal
	autoconf
	autoheader
	automake

	local myconf=

	use nls \
		|| myconf="${myconf} --disable-nls"

	myconf="${myconf} --with-zlib=/tmp/zlib/"

	econf ${myconf} || die
	MAKEOPTS="${MAKEOPTS} -j1" emake || die
}

src_install () {
	einstall mkinstalldirs=${S}/mkinstalldirs DESTDIR=${D} || die
}
