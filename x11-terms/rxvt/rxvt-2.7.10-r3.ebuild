# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt/rxvt-2.7.10-r3.ebuild,v 1.17 2008/05/03 15:35:49 opfer Exp $

inherit eutils flag-o-matic libtool

DESCRIPTION="rxvt -- nice small x11 terminal"
HOMEPAGE="http://rxvt.sourceforge.net/
	http://www.giga.it.okayama-u.ac.jp/~ishihara/opensource/"
SRC_URI="mirror://sourceforge/rxvt/${P}.tar.gz
	http://www.giga.it.okayama-u.ac.jp/~ishihara/opensource/${P}-xim-fix.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86"
IUSE="motif cjk xgetdefault linuxkeys"

RDEPEND="virtual/libc
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext
	motif? ( x11-libs/openmotif )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}

	epatch ${FILESDIR}/${P}-line-scroll.patch
	epatch ${FILESDIR}/${P}-asneeded.patch
	use motif && epatch ${FILESDIR}/${P}-azz4.diff
	if use cjk ; then
		epatch ${DISTDIR}/${P}-xim-fix.patch.gz
		if use linguas_ja ; then
			epatch ${FILESDIR}/${P}-rk.patch
		fi
	fi

	elibtoolize
}

src_compile() {

	local term
	if [ -n "${RXVT_TERM}" ] ; then
		term="${RXVT_TERM}"
	else
		term="rxvt"
	fi

	# bug #22325
	use linuxkeys && append-flags -DLINUX_KEYS
	append-ldflags $(bindnow-flags)

	econf \
		--enable-everything \
		--enable-rxvt-scroll \
		--enable-next-scroll \
		--enable-xterm-scroll \
		--enable-transparency \
		--enable-xpm-background \
		--enable-utmp \
		--enable-wtmp \
		--enable-mousewheel \
		--enable-slipwheeling \
		--enable-smart-resize \
		--enable-256-color \
		--enable-menubar \
		$(use_enable cjk languages) \
		--enable-xim \
		--enable-shared \
		--enable-keepscrolling \
		--with-term=${term} \
		$(use_enable xgetdefault) || die

	emake || die
}

src_install() {

	einstall mandir=${D}/usr/share/man/man1 || die

	cd ${S}/doc
	dodoc README* *.txt BUGS FAQ
	dohtml *.html
}

pkg_postinst() {

	einfo
	einfo "If you want to change default TERM variable other than rxvt,"
	einfo "set RXVT_TERM environment variable and then emerge rxvt."
	einfo "Especially, if you use rxvt under monochrome X you might need to run"
	einfo "\t RXVT_TERM=rxvt-basic emerge rxvt"
	einfo "otherwise curses based program will not work."
	einfo
}
