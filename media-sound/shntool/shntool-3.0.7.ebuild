# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shntool/shntool-3.0.7.ebuild,v 1.1 2008/03/19 08:35:16 aballier Exp $

IUSE="flac shorten sox wavpack"

DESCRIPTION="shntool is a multi-purpose WAVE data processing and reporting utility"
HOMEPAGE="http://shnutils.freeshell.org/shntool/"
SRC_URI="http://shnutils.freeshell.org/shntool/dist/src/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="flac? ( >=media-libs/flac-1.1.0 )
	sox? ( >=media-sound/sox-12.17.4 )
	shorten? ( media-sound/shorten )
	wavpack? ( media-sound/wavpack )"

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc doc/*
	dodoc NEWS README ChangeLog AUTHORS
}
