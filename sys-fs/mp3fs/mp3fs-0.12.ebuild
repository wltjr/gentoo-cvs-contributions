# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mp3fs/mp3fs-0.12.ebuild,v 1.2 2008/04/01 05:42:51 dragonheart Exp $

DESCRIPTION="MP3FS is a read-only FUSE filesystem which transcodes FLAC audio files to MP3 when read."
HOMEPAGE="http://mp3fs.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sys-fs/fuse
		media-libs/libid3tag
		media-libs/flac
		media-sound/lame"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
