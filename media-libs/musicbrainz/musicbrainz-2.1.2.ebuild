# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/musicbrainz/musicbrainz-2.1.2.ebuild,v 1.7 2006/08/08 21:31:58 tcort Exp $

inherit libtool

IUSE=""
DESCRIPTION="Client library to access metadata of mp3/vorbis/CD media"
HOMEPAGE="http://www.musicbrainz.org/"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/lib${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha amd64 ~hppa ia64 ~mips ppc ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND="dev-libs/expat"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/lib${P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	elibtoolize
}

src_compile() {
	econf --enable-cpp-headers || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog README TODO docs/mb_howto.txt
}
