# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cantus/cantus-1.07.ebuild,v 1.3 2003/09/08 07:09:44 msterret Exp $

DESCRIPTION="easy to use tool for tagging and renaming MP3 and OGG/Vorbis files"
HOMEPAGE="http://software.manicsadness.com/?site=project&project=1"
SRC_URI="http://sam.homeunix.com/software.manicsadness.com-step3/releases/cantus/${P}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="vorbis? ( media-libs/libvorbis
		media-libs/libogg )"

S="${WORKDIR}/${P}"

src_compile() {
	econf || die "configure failed"
	make || die "make failed"
}

src_install() {
	einstall || die "Install failed"
}

