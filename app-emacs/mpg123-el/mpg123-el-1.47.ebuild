# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/mpg123-el/mpg123-el-1.47.ebuild,v 1.4 2007/10/07 07:40:38 ulm Exp $

inherit elisp toolchain-funcs

DESCRIPTION="Emacs front-end to mpg123 audio player and OggVorbis audio player"
HOMEPAGE="http://www.gentei.org/~yuuji/software/mpg123el/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="vorbis"

DEPEND=""
RDEPEND="${DEPEND}
	virtual/mpg123
	media-sound/aumix
	vorbis? ( media-sound/vorbis-tools )"

SITEFILE=50${PN}-gentoo.el

src_compile(){
	sed -i -e "s/\(mainloop:\)/\1 ;/" tagput.c || die
	$(tc-getCC) ${CFLAGS} -o tagput tagput.c || die
	$(tc-getCC) ${CFLAGS} -o id3put id3put.c || die
	elisp-compile *.el
}

src_install(){
	dobin tagput || die
	dobin id3put || die

	elisp-install ${PN} *.el *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc README
}
