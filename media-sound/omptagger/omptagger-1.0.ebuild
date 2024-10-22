# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/omptagger/omptagger-1.0.ebuild,v 1.3 2007/11/25 13:37:33 corsair Exp $

DESCRIPTION="CLI utility for tagging FLAC, Ogg Vorbis and MP3 files"
HOMEPAGE="http://dev.gentoo.org/~omp/omptagger/"
SRC_URI="http://dev.gentoo.org/~omp/omptagger/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/ruby-1.8
	dev-ruby/id3lib-ruby
	media-libs/flac
	media-sound/vorbis-tools"

src_unpack() {
	unpack ${A}

	# The id3lib-ruby ebuild in the tree installs the gem, thus requiring
	# rubygems to be loaded prior to id3lib in any scripts using id3lib.
	sed -i -e "s/require 'id3lib'/require 'rubygems'\n\0/" \
		omptagger || die "sed failed"
}

src_install() {
	dobin omptagger || die "dobin failed"
}
