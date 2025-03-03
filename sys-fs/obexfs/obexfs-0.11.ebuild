# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/obexfs/obexfs-0.11.ebuild,v 1.2 2008/06/21 07:20:41 mr_bones_ Exp $

DESCRIPTION="FUSE filesystem interface for ObexFTP"
HOMEPAGE="http://dev.zuckschwerdt.org/openobex/wiki/ObexFs"
SRC_URI="http://triq.net/obexftp/${P/_/-}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-mobilephone/obexftp-0.22
	sys-fs/fuse"
RDEPEND=${DEPEND}

S="${WORKDIR}/${P%_*}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
