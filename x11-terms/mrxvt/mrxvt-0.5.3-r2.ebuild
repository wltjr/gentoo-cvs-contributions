# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/mrxvt/mrxvt-0.5.3-r2.ebuild,v 1.5 2008/05/06 17:38:43 dertobi123 Exp $

inherit eutils

DESCRIPTION="Multi-tabbed rxvt clone with XFT, transparent background and CJK support"
HOMEPAGE="http://materm.sourceforge.net/"
SRC_URI="mirror://sourceforge/materm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~mips ppc x86"

LINGUAS_IUSE="linguas_el linguas_ja linguas_ko linguas_th linguas_zh_CN linguas_zh_TW"
IUSE="debug png jpeg session truetype menubar utempter xpm ${LINGUAS_IUSE}"

RDEPEND="png? ( media-libs/libpng )
	utempter? ( sys-libs/libutempter )
	jpeg? ( media-libs/jpeg )
	truetype? ( virtual/xft
		media-libs/fontconfig
		media-libs/freetype )
	x11-libs/libX11
	x11-libs/libXt
	xpm? ( x11-libs/libXpm )
	x11-libs/libXrender"

DEPEND="${RDEPEND}
	x11-proto/xproto"

src_unpack() {

	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-no-scroll-with-buffer.patch"
	epatch "${FILESDIR}/${P}-display-security.patch"

}

src_compile() {

	local myconf

	# if you want to pass any other flags, use EXTRA_ECONF.
	if use linguas_el ; then
		myconf="${myconf} --enable-greek"
	fi
	if use linguas_ja ; then
		# --with-encoding=sjis
		myconf="${myconf} --enable-kanji --with-encoding=eucj"
	fi
	if use linguas_ko ; then
		myconf="${myconf} --enable-kr --with-encoding=kr"
	fi
	if use linguas_th ; then
		myconf="${myconf} --enable-thai"
	fi
	if use linguas_zh_CN ; then
		# --with-encoding=gbk
		myconf="${myconf} --enable-gb --with-encoding=gb"
	fi
	if use linguas_zh_TW ; then
		myconf="${myconf} --enable-big5 --with-encoding=big5"
	fi

	# 2006-03-13 gi1242: mrxvt works best with TERM=rxvt AND correctly set
	# termcap / terminfo entries. If the rxvt termcap / terminfo entries are
	# messed up then then it's better to set TERM=xterm.
	#
	# Provide support for this by setting the or RXVT_TERM environment variables
	# before emerging, as done in the rxvt ebuild.

	if [[ -n ${RXVT_TERM} ]]; then
		myconf="${myconf} --with-term=${RXVT_TERM}"
	fi

	econf \
		--enable-everything \
		--with-atab-extra=25 \
		$(use_enable debug) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable xpm) \
		$(use_enable session sessionmgr) \
		$(use_enable truetype xft) \
		$(use_enable utempter) \
		$(use_enable menubar) \
		${myconf} || die

	emake || die

}

src_install() {

	make DESTDIR="${D}" docdir=/usr/share/doc/${PF} install || die
	# Give mrxvt perms to update utmp
	fowners root:utmp /usr/bin/mrxvt
	fperms g+s /usr/bin/mrxvt
	dodoc AUTHORS CREDITS ChangeLog FAQ NEWS README* TODO

}

pkg_postinst() {

	if [[ -z $RXVT_TERM ]]; then
		einfo
		einfo "If you experience problems with curses programs, then this is"
		einfo "most likely because of incorrectly set termcap / terminfo"
		einfo "entries. To fix this you can dry and run (as user)"
		einfo "	tic /usr/share/doc/${P}/etc/mrxvt.terminfo"
		einfo "Alternately, run the offending programs with TERM=xterm."
		einfo
		einfo "To emerge mrxvt with TERM=xterm by default, set the RXVT_TERM"
		einfo "environment variable to 'xterm', or your desired default"
		einfo "terminal name. Alternately you can put 'Mrxvt.termName: xterm'"
		einfo "in your ~/.mrxvtrc, or /etc/mrxvt/mrxvtrc."
		einfo
	fi

}
